{
  lib,
  rustPlatform,
  pkg-config,
  libusb1,
}:
rustPlatform.buildRustPackage {
  pname = "quadcast-rgb";
  version = "0.1.0";

  src = lib.sourceByRegex ./. [
    "^Cargo\\.(toml|lock)$"
    "^src$"
    "^src/main\\.rs$"
  ];

  cargoLock.lockFile = ./Cargo.lock;

  nativeBuildInputs = [pkg-config];
  buildInputs = [libusb1];

  meta = {
    description = "One-shot RGB control for the HyperX QuadCast S (0951:171f)";
    license = lib.licenses.gpl2Only;
    mainProgram = "quadcast-rgb";
    platforms = lib.platforms.linux;
  };
}
