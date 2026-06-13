# Shared NixOS module imported by every media-server container.
# Underscore prefix: import-tree skips this as a flake module.
#
# Pins the `media` group GID to the same value as the host (default.nix)
# so bind-mounted directories have consistent ownership across all containers.
{ ... }:
{
  users.groups.media.gid = 900;
}
