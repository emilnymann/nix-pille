{
  lib,
  appimageTools,
  dwarfs,
  fetchurl,
  runCommand,
}: let
  pname = "wiiudownloader";
  version = "3.2";

  src = fetchurl {
    url = "https://github.com/Xpl0itU/WiiUDownloader/releases/download/v${version}/WiiUDownloader-Linux-x86_64.AppImage";
    hash = "sha256-4Nb9OiRLvgpJlJyOIq6ePnzIhCuRh+WOuuZjG+C4JtQ=";
  };

  # Upstream uses a quick-sharun / DwarFS AppImage rather than SquashFS, so
  # extract it with dwarfsextract instead of appimageTools.extract.
  contents = runCommand "${pname}-${version}-extracted" {nativeBuildInputs = [dwarfs];} ''
    mkdir -p "$out"
    dwarfsextract -i ${src} -O auto -o "$out"
  '';
in
  appimageTools.wrapAppImage {
    inherit pname version contents;

    extraInstallCommands = ''
      install -Dm444 ${contents}/WiiUDownloader.desktop \
        $out/share/applications/${pname}.desktop
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace-fail 'Exec=wiiudownloader' 'Exec=${pname}'
      install -Dm444 ${contents}/WiiUDownloader.png \
        $out/share/icons/hicolor/256x256/apps/WiiUDownloader.png
    '';

    meta = {
      description = "Cross-platform Wii U NUS downloader";
      homepage = "https://github.com/Xpl0itU/WiiUDownloader";
      license = lib.licenses.gpl3Only;
      mainProgram = "wiiudownloader";
      platforms = ["x86_64-linux"];
      sourceProvenance = [lib.sourceTypes.binaryNativeCode];
    };
  }
