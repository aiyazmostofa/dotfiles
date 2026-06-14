{
  config,
  lib,
  pkgs,
  ...
}:
{
  # https://librephoenix.com/2023-12-26-nixos-conditional-config-and-custom-options
  options.my = {
    name = lib.mkOption {
      type = lib.types.str;
    };
    username = lib.mkOption {
      type = lib.types.str;
    };
    hostName = lib.mkOption {
      type = lib.types.str;
    };
    timeZone = lib.mkOption {
      type = lib.types.str;
    };
    stateVersion = lib.mkOption {
      type = lib.types.str;
    };
    dotfiles = lib.mkOption {
      type = lib.types.str;
    };
  };

  config = {
    # Boot
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelPackages = pkgs.linuxPackages_latest;

    # Networking
    networking.hostName = config.my.hostName;
    networking.networkmanager.enable = true;

    # Time
    time.timeZone = config.my.timeZone;

    # Desktop environment
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

    # Printing
    services.printing.enable = true;

    # Audio
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # User
    users.users."${config.my.username}" = {
      isNormalUser = true;
      description = config.my.name;
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
        "libvirtd"
      ];
    };

    # https://wiki.nixos.org/wiki/Tailscale
    services.tailscale.enable = true;
    networking.nftables.enable = true;
    networking.firewall = {
      enable = true;
      trustedInterfaces = [ config.services.tailscale.interfaceName ];
      allowedUDPPorts = [ config.services.tailscale.port ];
    };
    systemd.services.tailscaled.serviceConfig.Environment = [
      "TS_DEBUG_FIREWALL_MODE=nftables"
    ];
    systemd.network.wait-online.enable = false;
    boot.initrd.systemd.network.wait-online.enable = false;

    # Terminal and shell
    programs.fish.enable = true;
    users.defaultUserShell = pkgs.fish;
    programs.direnv.enable = true;

    # Web browsing
    programs.firefox.enable = true;

    # Package management
    nixpkgs.config.allowUnfree = true;
    environment.systemPackages = with pkgs; [
      # Needed for Emacs
      cmakeMinimal
      emacs-pgtk
      gcc
      git
      gnumake
      libtool
      ripgrep

      # Containers and VMs
      distrobox
      gnome-boxes
      virt-manager

      # GNOME
      gnomeExtensions.alphabetical-app-grid
      gnomeExtensions.blur-my-shell
      gnomeExtensions.caffeine

      # Terminal
      ghostty
      just
      neovim
    ];

    # https://wiki.nixos.org/wiki/Automatic_system_upgrades
    system.autoUpgrade = {
      enable = true;
      dates = "daily";
    };

    # Podman and Docker
    virtualisation.podman.enable = true;
    virtualisation.docker.enable = true;

    # https://nixos.wiki/wiki/Libvirt
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
      };
    };

    # https://nixos.wiki/wiki/Flatpak
    services.flatpak.enable = true;
    systemd.services.flatpak-repo = {
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.flatpak ];
      script = ''
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      '';
    };

    # https://nixos.wiki/wiki/Storage_optimization
    nix.gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 14d";
    };

    # https://wiki.nixos.org/wiki/Fonts
    fonts.packages = with pkgs; [
      nerd-fonts.blex-mono
      ibm-plex
    ];

    # https://nixos.wiki/wiki/Flakes
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # https://matklad.github.io/2026/05/21/symlinking-nixos-dotfiles.html
    systemd.tmpfiles.rules =
      let
        createDir =
          p:
          lib.concatStringsSep " " [
            "d"
            "/home/${config.my.username}/.config${p}"
            "0755"
            config.my.username
            "users"
            "-"
            "-"
          ];
        link =
          p:
          lib.concatStringsSep " " [
            "L+"
            "/home/${config.my.username}/.config${p}"
            "-"
            "-"
            "-"
            "-"
            "${config.my.dotfiles}${p}"
          ];
      in
      [
        (createDir "")
        # Emacs
        (createDir "/emacs")
        (link "/emacs/init.el")
        (link "/emacs/lisp")
        (link "/emacs/snippets")
        # Fish
        (createDir "/fish")
        (link "/fish/config.fish")
        # Ghostty
        (createDir "/ghostty")
        (link "/ghostty/config.ghostty")
        # Git
        (createDir "/git")
        (link "/git/ignore")
      ];

    system.stateVersion = config.my.stateVersion;
  };
}
