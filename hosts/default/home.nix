{ config, pkgs, ... }:
let
  name = "Jonathan Vanderwater";
  email = "jonathan.vanderwater@gmail.com";
  githubUsername = "vanderwaterj";
in {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "vanderwaterj";
  home.homeDirectory = "/home/vanderwaterj";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.

  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

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

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
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

  home.sessionVariables = { EDITOR = "nvim"; };

  programs = {
    home-manager = { enable = true; };
    git = {
      enable = true;
      userName = "${name}";
      userEmail = "${email}";
    };
    kitty = {
      enable = true;
      themeFile = "Catppuccin-Mocha";
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      plugins = [
        # Base neovim plugins
        pkgs.vimPlugins.nvim-treesitter
        pkgs.vimPlugins.mason-nvim
        pkgs.vimPlugins.mason-lspconfig-nvim
        pkgs.vimPlugins.blink-cmp
        pkgs.vimPlugins.telescope-nvim
        pkgs.vimPlugins.telescope-fzf-native-nvim
        pkgs.vimPlugins.undotree

        pkgs.vimPlugins.nvim-tree-lua
        pkgs.vimPlugins.vim-tmux-navigator

        # Utility plugins
        pkgs.vimPlugins.which-key-nvim
        pkgs.vimPlugins.oil-nvim

        # Visual plugins
        pkgs.vimPlugins.nvim-web-devicons
        pkgs.vimPlugins.catppuccin-nvim
        pkgs.vimPlugins.lualine-nvim

        # Git plugins
        pkgs.vimPlugins.neogit
        pkgs.vimPlugins.gitsigns-nvim
      ];
      extraLuaConfig = ''
                require("catppuccin").setup({
                	flavour = "mocha",
                	styles = {
                		comments = { "italic" },
                		conditionals = { "italic" },
                	},
                	integrations = {
                		which_key = false,
                	},
                })
                vim.cmd.colorscheme "catppuccin"

                require('nvim-tree').setup({
                	view = {
                		side = "right",
                		width = 50,
                	},
                })
                require('mason').setup()
                require('mason-lspconfig').setup({
                	ensure_installed = {
                		"lua_ls",
                		"pyright",
                		"nil_ls",
                		"ts_ls",
                	}
                })

                require('oil').setup({
                	default_file_explorer = true,
                	columns = {
                		"icon",
                		"permissions",
                		"size",
                		"mtime",
                	},

                	-- Buffer-local options to use for oil buffers
                  	buf_options = {
                	    buflisted = false,
                	    bufhidden = "hide",
                	},

                	-- Window-local options to use for oil buffers
                	win_options = {
                		wrap = false,
                		signcolumn = "no",
                		cursorcolumn = false,
                		foldcolumn = "0",
                		spell = false,
                		list = false,
                		conceallevel = 3,
                		concealcursor = "nvic",
                	},
                	-- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
                	delete_to_trash = false,

                	-- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
                	skip_confirm_for_simple_edits = false,

                	-- Selecting a new/moved/renamed file or directory will prompt you to save changes first
                	-- (:help prompt_save_on_select_new_entry)
                	prompt_save_on_select_new_entry = true,
                	
                	-- Oil will automatically delete hidden buffers after this delay
                	-- You can set the delay to false to disable cleanup entirely
                	-- Note that the cleanup process only starts when none of the oil buffers are currently displayed
                	cleanup_delay_ms = 2000,
                	
                	lsp_file_methods = {
                		-- Enable or disable LSP file operations
                		enabled = true,

                		-- Time to wait for LSP file operations to complete before skipping
                		timeout_ms = 1000,

                		-- Set to true to autosave buffers that are updated with LSP willRenameFiles
                		-- Set to "unmodified" to only save unmodified buffers
                		autosave_changes = false,
                	},

                	-- Constrain the cursor to the editable parts of the oil buffer
                	-- Set to `false` to disable, or "name" to keep it on the file names
                	constrain_cursor = "editable",

                	-- Set to true to watch the filesystem for changes and reload oil
                	watch_for_changes = false,

                	-- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
                	-- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
                	-- Additionally, if it is a string that matches "actions.<name>",
                	-- it will use the mapping at require("oil.actions").<name>
                	-- Set to `false` to remove a keymap
                	-- See :help oil-actions for a list of all available actions
                	keymaps = {
                		["g?"] = { "actions.show_help", mode = "n" },
                		["<CR>"] = "actions.select",
                		["<C-s>"] = { "actions.select", opts = { vertical = true } },
                		["<C-h>"] = { "actions.select", opts = { horizontal = true } },
                		["<C-t>"] = { "actions.select", opts = { tab = true } },
                		["<C-p>"] = "actions.preview",
                		["<C-c>"] = { "actions.close", mode = "n" },
                		["<C-l>"] = "actions.refresh",
                		["-"] = { "actions.parent", mode = "n" },
                		["_"] = { "actions.open_cwd", mode = "n" },
                		["`"] = { "actions.cd", mode = "n" },
                		["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
                		["gs"] = { "actions.change_sort", mode = "n" },
                		["gx"] = "actions.open_external",
                		["g."] = { "actions.toggle_hidden", mode = "n" },
                		["g\\"] = { "actions.toggle_trash", mode = "n" },
                	},
                })

                require('gitsigns').setup {
                	signs = {
                		add          = { text = '┃' },
                		change       = { text = '┃' },
                		delete       = { text = '_' },
                		topdelete    = { text = '‾' },
                		changedelete = { text = '~' },
                		untracked    = { text = '┆' },
                	},
                	signs_staged = {
                		add          = { text = '┃' },
                		change       = { text = '┃' },
                		delete       = { text = '_' },
                		topdelete    = { text = '‾' },
                		changedelete = { text = '~' },
                		untracked    = { text = '┆' },
                	},
                	signs_staged_enable = true,
                	signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
                	numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
                	linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
                	word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
                	watch_gitdir = {
                		follow_files = true
                	},
                	auto_attach = true,
                	attach_to_untracked = false,
                	current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
                	current_line_blame_opts = {
                		virt_text = true,
                		virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
                		delay = 1000,
                		ignore_whitespace = false,
                		virt_text_priority = 100,
                		use_focus = true,
                	},
                	current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
                	sign_priority = 6,
                	update_debounce = 100,
                	status_formatter = nil, -- Use default
                	max_file_length = 40000, -- Disable if file is longer than this (in lines)
                	preview_config = {
                		-- Options passed to nvim_open_win
                		border = 'single',
                		style = 'minimal',
                		relative = 'cursor',
                		row = 0,
                		col = 1
                	},
                }

                require('neogit').setup()
                require('blink-cmp').setup()
                require('nvim-treesitter').setup()

                require('telescope').setup()
                require('telescope').load_extension('fzf')

                require('lualine').setup({
                  options = {
                    icons_enabled = true,
                    theme = "auto",
                    component_separators = { left = '', right = ''},
                    section_separators = { left = '', right = ''},
                    disabled_filetypes = {
                      statusline = {},
                      winbar = {},
                    },
                    ignore_focus = {},
                    always_divide_middle = true,
                    always_show_tabline = true,
                    globalstatus = false,
                    refresh = {
                      statusline = 100,
                      tabline = 100,
                      winbar = 100,
                    }
                  },
                  sections = {
                    lualine_a = {'mode'},
                    lualine_b = {'branch', 'diff', 'diagnostics'},
                    lualine_c = {'filename'},
                    lualine_x = {'encoding', 'fileformat', 'filetype'},
                    lualine_y = {'progress'},
                    lualine_z = {'location'}
                  },
                  inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = {'filename'},
                    lualine_x = {'location'},
                    lualine_y = {},
                    lualine_z = {}
                  },
                  tabline = {},
                  winbar = {},
                  inactive_winbar = {},
                  extensions = {}
                })

                vim.opt.relativenumber = true

                -- KEYBINDINGS
                vim.g.mapleader = " "        --   Must be before all other keybinds
                vim.g.maplocalleader = " "   --   ^                               ^

                -- Tmux-style navigation
                vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
                vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
                vim.keymap.set('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
                vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })

                -- Center screen after half-page scroll
                vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true })
                vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true })

                -- Telescope controls
                vim.keymap.set("n", "<leader>sf", "<cmd>Telescope find_files<cr>", { desc = "Search files" })
                vim.keymap.set("n", "<leader>sg", "<cmd>Telescope live_grep<cr>", { desc = "Search grep" })
                vim.keymap.set("n", "<leader>sb", "<cmd>Telescope buffers<cr>", { desc = "Search buffers" })
                vim.keymap.set("n", "<leader>sh", "<cmd>Telescope help_tags<cr>", { desc = "Search help" })

                -- Oil controls
                vim.keymap.set("n", "<C-b>", "<cmd>Oil<cr>", { desc = "Open oil buffer" })
                -- vim.keymap.set('n', '<C-b>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

        	-- AUTOCMDS

        	-- Set tab width for .nix files
        	vim.api.nvim_create_autocmd("FileType", {
        	    pattern = "nix",
        	    callback = function()
        		vim.bo.tabstop = 2        -- Number of spaces that a <Tab> counts for
        		vim.bo.shiftwidth = 2     -- Number of spaces for autoindent
        		vim.bo.expandtab = true   -- Use spaces instead of tabs
        	    end,
        	})
      '';
    };
    tmux = {
      enable = true;
      clock24 = true;
      prefix = "C-Space";
      extraConfig = ''
        # Smart pane switching with awareness of Vim splits.
        # See: https://github.com/christoomey/vim-tmux-navigator
        is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
            | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?|fzf)(diff)?$'"
        bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
        bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
        bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
        bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
        tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
        if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
            "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
        if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
            "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

        bind-key -T copy-mode-vi 'C-h' select-pane -L
        bind-key -T copy-mode-vi 'C-j' select-pane -D
        bind-key -T copy-mode-vi 'C-k' select-pane -U
        bind-key -T copy-mode-vi 'C-l' select-pane -R
        bind-key -T copy-mode-vi 'C-\' select-pane -l
      '';
    };
  };
}
