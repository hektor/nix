{ lib, config, ... }:
let
  username = config.ssh.username;
in
{
  # auto extract SSH keys
  system.activationScripts.extractSshKeys = lib.stringAfter [ "etc" ] ''
    HOST_KEY="/etc/ssh/ssh_host_ed25519_key.pub"
    HOST_DIR="/home/${username}/nix/hosts/${config.networking.hostName}"

    if [ -f "$HOST_KEY" ] && [ -d "$HOST_DIR" ]; then
      cp "$HOST_KEY" "$HOST_DIR/ssh_host.pub"
      chown ${username}:users "$HOST_DIR/ssh_host.pub"
      chmod 644 "$HOST_DIR/ssh_host.pub"
    fi

    USER_KEY="/home/${username}/.ssh/id_ed25519.pub"
    if [ -f "$USER_KEY" ] && [ -d "$HOST_DIR" ]; then
      cp "$USER_KEY" "$HOST_DIR/ssh_user.pub"
      chown ${username}:users "$HOST_DIR/ssh_user.pub"
      chmod 644 "$HOST_DIR/ssh_user.pub"
    fi
  '';
}
