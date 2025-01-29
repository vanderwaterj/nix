# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
  ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.efiSupport = true;

  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Configure keymaps in X11
  services = {
    displayManager = {
      autoLogin = {
        enable = true;
        user = "vanderwaterj";
      };
      sddm.enable = true; # KDE Plasma
    };
    xserver = {
      enable = true;
      xkb = {
        options = "ctrl:nocaps";
        layout = "us";
        variant = "";
      };
    };
    desktopManager.plasma6.enable = true; # Enable the KDE Plasma Desktop Environment.
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.vanderwaterj = {
    isNormalUser = true;
    description = "Jonathan Vanderwater";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      kdePackages.kate
      #  thunderbird
    ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "vanderwaterj" = import ./home.nix;
    };
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment.systemPackages = with pkgs; [
    # Text Editors and IDEs
    vim # Classic Vim text editor
    neovim # Modernized Vim with Lua scripting

    # Shell and Terminal Tools
    kitty # Fast and feature-rich terminal emulator
    tmux # Terminal multiplexer for session management
    zsh # Terminal
    oh-my-zsh # zsh configuration
    zsh-autosuggestions
    zsh-powerlevel10k

    # Programming Languages and Tools
    rustup # Rust language version manager
    cargo # Rust package manager
    gcc # GNU Compiler Collection for C/C++
    gnumake # GNU Make build automation tool
    nodejs # JavaScript runtime for building and running Node.js apps
    python314 # Python 3.14 programming language
    ghc # Glasgow Haskell Compiler

    openjdk17-bootstrap # Java runtime
    scala # Scala 3 programming language
    coursier # Scala dependency manager
    sbt # Build tool for Scala & Java

    xclip # Clipboard utility

    # Web and Networking Utilities
    wget # Command-line utility for downloading files

    # Productivity Tools
    eza # Modern replacement for `ls` with more features
    neofetch # Display system stats
    tree

    # Source Control
    git # Distributed version control system
    gh # GitHub CLI for managing GitHub repositories

    # File Searching and Navigation
    ripgrep # Fast recursive search tool
    fzf # Command-line fuzzy finder

    # Code Formatters and Linters
    nixfmt-rfc-style # Formatter for Nix files in RFC style
    treefmt # Universal file formatter manager
    stylua # Formatter for Lua code

    discord
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.iosevka-term
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
