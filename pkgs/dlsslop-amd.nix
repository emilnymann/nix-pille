{
  lib,
  stdenv,
  fetchgit,
  src,
  bash,
  coreutils,
  cmake,
  directx-shader-compiler,
  glslang,
  git,
  libXi,
  libx11,
  makeWrapper,
  ninja,
  python3,
  spirv-tools,
  util-linux,
  vulkan-headers,
  vulkan-loader,
  qt6,
  llvmPackages_22,
}:
let
  lock = builtins.fromJSON (builtins.readFile "${src}/upstreams.lock.json");

  # dlsslop-amd records exactly which files it consumes from each upstream.
  # Sparse, pinned checkouts avoid pulling OptiScaler's unrelated binary assets.
  upstreamHashes = {
    layer = "sha256-sncrdvM82RJtXKc9F5sik/eSnbevctb9BhJz8up1X98=";
    amd = "sha256-W35MUnUSt5BbTJJ9GAz69K31ZNBlQit4EGV/wbObY5Q=";
    optiscaler = "sha256-TU1WuIjG0LqXsdySHxM9sk6QHb6f8dv/EeC7cUS5c0A=";
  };

  sourcesFor = repository:
    builtins.attrValues (
      lib.filterAttrs (_: file: file.repository == repository) lock.files
    );

  upstreams = lib.mapAttrs (name: repository:
    fetchgit {
      url = repository.url;
      rev = repository.commit;
      hash = upstreamHashes.${name};
      fetchSubmodules = false;
      nonConeMode = true;
      sparseCheckout = lib.unique (map (file: "/${file.source}") (sourcesFor name));
    }) lock.repositories;

  sourceCopies = lib.concatMapStringsSep "\n" (target:
    let
      file = lock.files.${target};
      source = "${upstreams.${file.repository}}/${file.source}";
    in ''
      mkdir -p "$(dirname ${lib.escapeShellArg target})"
      cp -- ${lib.escapeShellArg source} ${lib.escapeShellArg target}
    '') (builtins.attrNames lock.files);

  sourceChecksums = lib.concatMapStringsSep "\n" (target:
    "${lock.files.${target}.sha256}  ${target}") (builtins.attrNames lock.files);

  outputChecksums = lib.concatMapStringsSep "\n" (target:
    "${lock.outputs.${target}}  ${target}") (builtins.attrNames lock.outputs);

  sourceModes = lib.concatMapStringsSep "\n" (target: ''
    chmod "$(printf '%o' ${toString lock.modes.${target}})" -- ${lib.escapeShellArg target}
  '') (builtins.attrNames lock.modes);

  pythonEnv = python3.withPackages (ps: [ ps.numpy ps.pillow ]);
in
stdenv.mkDerivation {
  pname = "dlsslop-amd";
  version = "0.1.0";
  inherit src;

  strictDeps = true;
  nativeBuildInputs = [
    bash
    cmake
    directx-shader-compiler
    git
    glslang
    llvmPackages_22.clang-unwrapped
    llvmPackages_22.lld
    makeWrapper
    ninja
    pythonEnv
    spirv-tools
    util-linux
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    libXi
    qt6.qtbase
    vulkan-headers
    vulkan-loader
    libx11
  ];

  dontConfigure = true;
  doCheck = true;

  patchPhase = ''
    runHook prePatch

    ${sourceCopies}
    cat > "$TMPDIR/source-files.sha256" <<'EOF'
    ${sourceChecksums}
    EOF
    sha256sum --check "$TMPDIR/source-files.sha256"

    git init --quiet
    git apply --binary patches/linux-integration.patch

    cat > "$TMPDIR/patched-files.sha256" <<'EOF'
    ${outputChecksums}
    EOF
    sha256sum --check "$TMPDIR/patched-files.sha256"
    ${sourceModes}

    # Upstream CI runs on an FHS Ubuntu host. Point its tests at Nix store tools.
    python3 - <<'PYTESTPATCH'
    from pathlib import Path

    replacements = {
        "tests/launcher-cli.py": [
            ('"/usr/bin/bash"', '"${bash}/bin/bash"'),
            ('"/usr/bin/true"', '"${coreutils}/bin/true"'),
            ('bad_flock.write_text("#!/usr/bin/bash\\nexit 42\\n")',
             'bad_flock.write_text("#!${bash}/bin/bash\\nexit 42\\n")'),
        ],
        "tests/packaging_test.py": [
            ('"/usr/bin/bash"', '"${bash}/bin/bash"'),
            ('shutil.copyfile("/usr/bin/true", target)',
             'subprocess.run(["cc", "-x", "c", "-o", str(target), "-"], input="int main(void) { return 0; }", text=True, check=True)'),
            ('run([prefix / "bin" / name, "--help"], env)',
             'run(["${pythonEnv}/bin/python3", prefix / "bin" / name, "--help"], env)'),
            ('[prefix / "bin/dlsslop-setup", "--help"]',
             '["${pythonEnv}/bin/python3", prefix / "bin/dlsslop-setup", "--help"]'),
        ],
    }
    for name, pairs in replacements.items():
        path = Path(name)
        text = path.read_text()
        for old, new in pairs:
            if old not in text:
                raise SystemExit(f"test compatibility patch did not match {name}: {old!r}")
            text = text.replace(old, new)
        path.write_text(text)
    PYTESTPATCH

    runHook postPatch
  '';

  buildPhase = ''
    runHook preBuild

    export LD_LIBRARY_PATH="${directx-shader-compiler}/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
    python3 scripts/build-all-shaders.py --dxc "${directx-shader-compiler}/bin/dxc"
    python3 scripts/build-kernels.py \
      --compiler "${llvmPackages_22.clang-unwrapped}/bin/clang++" \
      --linker "${llvmPackages_22.lld}/bin/ld.lld"

    cmake -S . -B build -G Ninja \
      -DCMAKE_BUILD_TYPE=Release \
      -DDLSSLOP_BUILD_GUI=ON \
      -DBUILD_TESTING=ON \
      -DPython3_EXECUTABLE="${pythonEnv}/bin/python3"
    cmake --build build --parallel "''${NIX_BUILD_CORES:-2}"

    runHook postBuild
  '';

  checkPhase = ''
    runHook preCheck
    QT_QPA_PLATFORM=offscreen ctest --test-dir build --output-on-failure
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    python3 install.py \
      --prefix "$out" \
      --build-dir "$PWD/build" \
      --manifest-dir "$out/share/vulkan/implicit_layer.d"
    runHook postInstall
  '';

  postFixup = ''
    substituteInPlace "$out/bin/dlsslop-run" \
      --replace-fail '#!/usr/bin/bash' '#!${bash}/bin/bash'
    substituteInPlace "$out/bin/dlsslop-test" "$out/bin/dlsslop-setup" \
      --replace-fail '#!/usr/bin/python3' '#!${pythonEnv}/bin/python3'

    wrapProgram "$out/bin/dlsslop-run" \
      --prefix PATH : "${lib.makeBinPath [ util-linux ]}"
  '';

  meta = {
    description = "Experimental DLSS-style neural presentation layer for AMD gfx1201 GPUs";
    homepage = "https://github.com/imaami/dlsslop-amd";
    license = lib.licenses.agpl3Only;
    mainProgram = "dlsslopd";
    platforms = [ "x86_64-linux" ];
  };
}
