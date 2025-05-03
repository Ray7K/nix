{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ../../modules/home-manager/dev.nix
  ];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "ray";
  home.homeDirectory = "/home/ray";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  targets.genericLinux.enable = true;
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    btop
    htop
    neovim
    hyprpaper
    waybar
    rofi-wayland
    kitty
    ripgrep
    unzip
    yazi
    imagemagick
    ghostscript
    pandoc
    ffmpeg
    sqlite
    pywal
    wl-clipboard
    xclip
    copyq
    jq
    inputs.zen-browser.packages.${pkgs.system}.default

    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts.code-new-roman
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    fira-code
    jetbrains-mono
  ];

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
    "${config.home.homeDirectory}/.local/scripts"
  ];

  home.shell.enableZshIntegration = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;

    shellAliases = {
      ls = "eza";
    };

    initContent = ''
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

      set -g renumber-windows on

      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R

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

  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      schema = "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json";

      # Palette
      palette = {
        blue = "#7aa2f7";
        closer = "p:os";
        cyan = "#b4f9f8";
        green = "#c3e88d";
        os = "#a9b1d6";
      };

      # Secondary Prompt
      secondary_prompt = {
        template = "❯❯ ";
        foreground = "#c0cef5";
        background = "transparent";
      };

      # Transient Prompt
      transient_prompt = {
        template = "❯ ";
        background = "transparent";
        foreground_templates = [
          "{{if gt .Code 0}}#cfcef5{{end}}"
          "{{if eq .Code 0}}#c0cef5{{end}}"
        ];
      };

      # Console Title Template
      console_title_template = "{{ .Shell }} in {{ .Folder }}";

      # Blocks (you may want to change this structure if it becomes more complex)
      blocks = [
        {
          type = "prompt";
          alignment = "left";
          segments = [
            {
              properties = {
                cache_duration = "none";
              };
              template = "{{.Icon}} ";
              foreground = "p:os";
              type = "os";
              style = "plain";
            }
            {
              properties = {
                cache_duration = "none";
              };
              template = "{{ .UserName }} ";
              foreground = "p:blue";
              type = "session";
              style = "plain";
            }
            {
              properties = {
                cache_duration = "none";
                folder_icon = "  ";
                home_icon = "~";
                style = "agnoster_short";
                max_depth = 2;
              };
              template = "{{ .Path }} ";
              foreground = "p:cyan";
              type = "path";
              style = "plain";
            }
            {
              properties = {
                cache_duration = "none";
                branch_icon = " ";
                cherry_pick_icon = " ";
                commit_icon = " ";
                fetch_status = true;
                fetch_upstream_icon = true;
                merge_icon = " ";
                no_commits_icon = " ";
                rebase_icon = " ";
                revert_icon = " ";
                tag_icon = " ";
              };
              template = "{{ .HEAD }}{{if .BranchStatus }} {{ .BranchStatus }}{{ end }}{{ if .Working.Changed }}   {{ .Working.String }}{{ end }}{{ if and (.Staging.Changed) (.Working.Changed) }} |{{ end }}{{ if .Staging.Changed }}  {{ .Staging.String }}{{ end }}";
              foreground = "p:green";
              type = "git";
              style = "plain";
            }
          ];
          newline = true;
        }
        {
          type = "rprompt";
          overflow = "#6fb9e3";
          segments = [
            {
              properties = {
                cache_duration = "none";
                threshold = 2500;
              };
              template = "{{ .FormattedMs }}";
              foreground = "#cde4fa";
              background = "transparent";
              type = "executiontime";
              style = "plain";
            }
          ];
        }
        {
          type = "prompt";
          alignment = "left";
          segments = [
            {
              properties = {
                cache_duration = "none";
              };
              template = "❯";
              background = "transparent";
              type = "text";
              style = "plain";
              foreground_templates = [
                "{{if gt .Code 0}}#cfcef5{{end}}"
                "{{if eq .Code 0}}#c0cef5{{end}}"
              ];
            }
          ];
          newline = true;
        }
      ];

      version = 3;
      final_space = true;
    };
  };

  programs.fastfetch.enable = true;
  programs.fd.enable = true;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".config/ghostty".source = "${inputs.dotfiles-linux}/ghostty";
    ".config/nvim".source = "${inputs.dotfiles-linux}/nvim";
    ".config/hypr".source = "${inputs.dotfiles-linux}/hypr";
    ".config/waybar".source = "${inputs.dotfiles-linux}/waybar";
    ".config/bat/themes".source = "${inputs.dotfiles-linux}/bat/themes";
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
  #  /etc/profiles/per-user/ray/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true;

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 20;
  };

  gtk = {
    enable = true;
    theme = {
      name = "Graphite-Dark";
      package = pkgs.graphite-gtk-theme;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 20;
    };
  };

  programs.git = {
    enable = true;
    userName = "Ray7K";
    userEmail = "173786719+Ray7K@users.noreply.github.com";
    delta.enable = true;
  };

}
