{ config, pkgs, ... }:
let
  name = "Jonathan Vanderwater";
  email = "jonathan.vanderwater@gmail.com";
  githubUsername = "vanderwaterj";
in
{
  home.username = "vanderwaterj";
  home.homeDirectory = "/home/vanderwaterj";

  # Check the Home Manager release notes before changing stateVersion
  home.stateVersion = "24.11";

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    pkgs.lua-language-server
    pkgs.typescript-language-server

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  home.file = {
    "./config/.tmux.conf".source = ./config/.tmux.conf;
    "./config/init.lua".source = ./config/init.lua;
    ".p10k.zsh".source = ./.p10k.zsh;
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/vanderwaterj/etc/profile.d/hm-session-vars.sh
  #

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs = {
    home-manager = {
      enable = true;
    };
    git = {
      enable = true;
      userName = "${name}";
      userEmail = "${email}";
    };
    kitty = {
      enable = true;
      themeFile = "Catppuccin-Mocha";
      font = {
        name = "IosevkaTerm Nerd Font";
        size = 14;
      };
      settings = {
        shell = "zsh";
      };
    };
    zsh = {
      enable = true;
      shellAliases = {
        rebuild = "sudo nixos-rebuild switch --flake ~/dev/nix#default";
      };
      syntaxHighlighting.enable = true;
      autosuggestion.enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [
          "eza"
        ];
      };
      initExtra = ''
        source ./.p10k.zsh
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      '';
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      plugins = [
        # Base neovim plugins
        pkgs.vimPlugins.lazy-nvim

        pkgs.vimPlugins.nvim-treesitter
        pkgs.vimPlugins.mason-nvim
        pkgs.vimPlugins.mason-lspconfig-nvim
        pkgs.vimPlugins.blink-cmp
        pkgs.vimPlugins.telescope-nvim
        pkgs.vimPlugins.telescope-fzf-native-nvim
        pkgs.vimPlugins.undotree

        pkgs.vimPlugins.vim-tmux-navigator

        # Utility plugins
        pkgs.vimPlugins.which-key-nvim
        pkgs.vimPlugins.oil-nvim

        # Visual plugins
        pkgs.vimPlugins.nvim-web-devicons
        pkgs.vimPlugins.catppuccin-nvim
        pkgs.vimPlugins.lualine-nvim
        pkgs.vimPlugins.alpha-nvim
        pkgs.vimPlugins.noice-nvim

        # Git plugins
        pkgs.vimPlugins.neogit
        pkgs.vimPlugins.gitsigns-nvim
      ];
      extraLuaConfig = builtins.readFile ./config/init.lua;
    };
    tmux = {
      enable = true;
      clock24 = true;
      prefix = "C-Space";
      extraConfig = builtins.readFile ./config/.tmux.conf;
    };
  };
}
