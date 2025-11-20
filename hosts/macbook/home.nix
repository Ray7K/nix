{
  lib,
  inputs,
  config,
  pkgs,
  ...
}:

{
  imports = [ ../../modules/home-manager/dev.nix ];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "raiyankataria";
  home.homeDirectory = "/Users/raiyankataria";

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
  home.packages = with pkgs; [
    vim
    neovim
    ripgrep
    btop
    htop
    fastfetch
    fd
    yazi

    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];

  home.file = {
    ".config/ghostty".source = "${inputs.dotfiles-mac}/ghostty";
    ".config/nvim".source = "${inputs.dotfiles-mac}/nvim";
    ".config/karabiner".source = "${inputs.dotfiles-mac}/karabiner";
    ".aerospace.toml".source = "${inputs.dotfiles-mac}/.aerospace.toml";
    ".config/bat/themes".source = "${inputs.dotfiles-mac}/bat/themes";
    ".local/scripts".source = "${inputs.dotfiles-mac}/scripts";
  };

  home.sessionPath = [
    "/opt/homebrew/opt/llvm/bin/"
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.shell.enableZshIntegration = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;

    shellAliases = {
      ls = "eza";
    };

    initContent = lib.mkOrder 550 ''
      eval "$(/opt/homebrew/bin/brew shellenv)"

      BLOCK='\e[2 q'
      BEAM='\e[6 q'

      function zle-line-init zle-keymap-select {
        if [[ $KEYMAP == vicmd ]] || [[ $1 = 'block' ]]; then
          echo -ne $BLOCK
        elif [[ $KEYMAP == main ]] || [[ $KEYMAP == viins ]] ||
             [[ $KEYMAP = '''''' ]] || [[ $1 = 'beam' ]]; then
          echo -ne $BEAM
        fi
      }

      export KEYTIMEOUT=1

      zle -N zle-line-init
      zle -N zle-keymap-select

      bindkey -v
      bindkey -s ^f "tmux-sessionizer\n"
      bindkey -M vicmd '^e' edit-command-line

      bindkey '^H' backward-delete-char  # Backspace (often ^H) key
      bindkey '^?' backward-delete-char  # For some terminals, backspace sends ^?

      autoload -Uz add-zle-hook-widget
      add-zle-hook-widget line-init vi-cmd-mode
    '';
  };

  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    historyLimit = 50000;
    focusEvents = true;
    mouse = true;
    prefix = "C-s";
    keyMode = "vi";
    escapeTime = 0;
    baseIndex = 1;
    extraConfig = ''
      set-option -g set-titles on
      set-option -g set-titles-string "#{pane_title}"

      bind-key S send-prefix

      set -g renumber-windows on

      bind-key -r f run-shell "tmux neww ~/.local/scripts/tmux-sessionizer"
    '';
    plugins = with pkgs; [
      tmuxPlugins.yank
      tmuxPlugins.vim-tmux-navigator
      {
        plugin = tmuxPlugins.tokyo-night-tmux;
        extraConfig = ''
          set -g @tokyo-night-tmux_theme 'night'
          set -g @tokyo-night-tmux_transparent 1
          set -g @tokyo-night-tmux_window_id_style fsquare
          set -g @tokyo-night-tmux_pane_id_style hsquare
          set -g @tokyo-night-tmux_zoom_id_style dsquare
        '';
      }
    ];
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Ray7K";
        email = "173786719+Ray7K@users.noreply.github.com";
      };
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.eza = {
    enable = true;
    git = true;
    icons = "auto";
    theme = "tokyonight";
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "tokyonight";
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      git = {
        paging = {
          colorArg = "always";
          pager = "delta --dark --paging=never";
        };
      };
    };
  };

  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    settings = builtins.fromJSON (builtins.readFile "${inputs.dotfiles-mac}/oh-my-posh/config.json");
  };

  programs.fastfetch.enable = true;
  programs.fd.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

}
