{ pkgs, ... }:

let
  tmuxInitScript = pkgs.writeShellScript "tmux-init" ''
    exec sh "$HOME/src/myconfigfiles/scripts/tmux_session.sh" "$@"
  '';

  tmuxConf = ''
    # Initial setup
    set -g default-terminal xterm-256color
    set -g status-keys vi


    # use C-j and C-f for the prefix.
    set-option -g prefix C-b
    set-option -g prefix2 C-f
    unbind-key C-j
    bind-key C-j send-prefix
    set -g base-index 1


    # Use Alt-arrow keys without prefix key to switch panes
    bind -n M-h select-pane -L
    bind -n M-l select-pane -R
    bind -n M-K select-pane -U
    bind -n M-J select-pane -D


    # Set easier window split keys
    bind-key v split-window -h
    bind-key h split-window -v


    # Shift arrow to switch windows
    bind -n M-Left  previous-window
    bind -n M-Right next-window


    # Easily reorder windows with CTRL+SHIFT+Arrow
    bind-key -n C-S-Left swap-window -t -1
    bind-key -n C-S-Right swap-window -t +1


    # Synchronize panes
    bind-key y set-window-option synchronize-panes\; display-message "synchronize mode toggled."


    # Easy config reload
    bind-key r source-file ~/.tmux.conf \; display-message "tmux.conf reloaded."


    # Easy clear history
    bind-key L clear-history


    # Key bindings for copy-paste
    setw -g mode-keys vi
    unbind p
    bind p paste-buffer
    bind-key -T copy-mode-vi 'v' send -X begin-selection
    bind-key -T copy-mode-vi 'y' send -X copy-selection-and-cancel


    # Mouse Mode
    set -g mouse on


    # Lengthen the amount of time status messages are displayed
    set-option -g display-time 3000
    set-option -g display-panes-time 3000


    # Set the base-index to 1 rather than 0
    set -g base-index 1
    set-window-option -g pane-base-index 1


    # Automatically set window title
    set-window-option -g automatic-rename on
    set-option -g set-titles on


    # Allow the arrow key to be used immediately after changing windows.
    set-option -g repeat-time 0


    # No delay for escape key press
    set -sg escape-time 0

    # Change background color of a tab when activity occurs
    setw -g monitor-activity on


    # Do NOT reset the color of the tab after activity stops occuring
    setw -g monitor-silence 0


    # Disable bell
    setw -g monitor-bell off


    # Disable visual text box when activity occurs
    set -g visual-activity off

    ### THEME: MATTE BLACK ###
    # Base colors
    set -g status-bg "#0f0f0f"
    set -g status-fg "#bbbbbb"

    # Active window
    set -g window-status-current-style fg="#ffffff",bg="#232323",bold

    # Inactive windows
    set -g window-status-style fg="#666666",bg="#0f0f0f"

    # Pane borders
    set -g pane-border-style fg="#333333"
    set -g pane-active-border-style fg="#888888"

    # Message appearance (for prompts, searches, etc.)
    set -g message-style bg="#1a1a1a",fg="#cccccc"

    # Status left/right configuration
    set -g status-left-length 40
    set -g status-right-length 80

    set -g status-left "#[fg=#888888,bg=#0f0f0f] #S #[default]"
    set -g status-right "#[fg=#555555,bg=#0f0f0f] %Y-%m-%d #[fg=#888888]| %H:%M #[default]"

    # Window list style
    setw -g window-status-format " #[fg=#555555]#I:#W "
    setw -g window-status-current-format " #[fg=#ffffff,bg=#232323]#I:#W* "

    # Remove visual clutter
    set -g status-justify centre
    set -g status-interval 5

    ### Optional: Better copy mode colors ###
    set -g mode-style bg="#1a1a1a",fg="#cccccc"
  '';
in
{
  home.packages = with pkgs; [
    ripgrep
    fzf
    highlight
  ];

  programs.fish = {
    enable = true;

    shellInit = ''
      fish_add_path --move --prepend $HOME/.cargo/bin
      fish_add_path --move --prepend $HOME/go/bin
    '';

    shellAliases = {
      vim = "nvim";
    };

    shellAbbrs = {
      l = "eza --icons -la";
      lt = "eza -la -T --level=2 --icons";
      ls = "eza";
    };

    interactiveShellInit = ''
      set -g fish_color_autosuggestion 585858
      set -g fish_color_cancel --reverse
      set -g fish_color_command a1b56c
      set -g fish_color_comment f7ca88
      set -g fish_color_cwd green
      set -g fish_color_cwd_root red
      set -g fish_color_end ba8baf
      set -g fish_color_error ab4642
      set -g fish_color_escape 86c1b9
      set -g fish_color_history_current --bold
      set -g fish_color_host normal
      set -g fish_color_host_remote normal
      set -g fish_color_keyword normal
      set -g fish_color_match 7cafc2
      set -g fish_color_normal normal
      set -g fish_color_operator 7cafc2
      set -g fish_color_option normal
      set -g fish_color_param d8d8d8
      set -g fish_color_quote f7ca88
      set -g fish_color_redirection d8d8d8
      set -g fish_color_search_match white --background=brblack
      set -g fish_color_selection white --bold --background=brblack
      set -g fish_color_status red
      set -g fish_color_user brgreen
      set -g fish_color_valid_path --underline

      set -g fish_pager_color_background normal
      set -g fish_pager_color_completion normal
      set -g fish_pager_color_description B3A06D
      set -g fish_pager_color_prefix normal --bold --underline
      set -g fish_pager_color_progress brwhite --background=cyan
      set -g fish_pager_color_secondary_background normal
      set -g fish_pager_color_secondary_completion normal
      set -g fish_pager_color_secondary_description normal
      set -g fish_pager_color_secondary_prefix normal
      set -g fish_pager_color_selected_background --background=brblack
      set -g fish_pager_color_selected_completion normal
      set -g fish_pager_color_selected_description normal
      set -g fish_pager_color_selected_prefix normal

      ${pkgs.fzf}/bin/fzf --fish | source
    '';

    functions = {
      envsource = ''
        set -f envfile "$argv"
        if not test -f "$envfile"
          echo "Unable to load $envfile"
          return 1
        end

        while read line
          if not string match -qr '^#|^$' "$line"
            set item (string split -m 1 '=' $line)
            set -gx $item[1] $item[2]
            echo "Exported key $item[1]"
          end
        end < "$envfile"
      '';

      fif = ''
        if count $argv > /dev/null
          set -f sstr "$argv"
          rg --files-with-matches --no-messages "$sstr" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$sstr' || rg --ignore-case --pretty --context 10 '$sstr' {}"
        else
          echo "Please provide a search string"
        end
      '';

      fish_greeting = ''
        fastfetch
      '';

      fish_prompt = ''
        set -l last_pipestatus $pipestatus
        set -lx __fish_last_status $status

        if functions -q fish_is_root_user; and fish_is_root_user
          printf '%s@%s %s%s%s# ' $USER (prompt_hostname) (set -q fish_color_cwd_root; and set_color $fish_color_cwd_root; or set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
        else
          set -l status_color (set_color $fish_color_status)
          set -l statusb_color (set_color --bold $fish_color_status)
          set -l pipestatus_string (__fish_print_pipestatus "[" "]" "|" "$status_color" "$statusb_color" $last_pipestatus)

          printf '[%s] %s%s@%s %s%s %s%s%s \n> ' (date "+%H:%M:%S") (set_color brblue) $USER (prompt_hostname) (set_color $fish_color_cwd) $PWD $pipestatus_string (set_color normal)
        end
      '';

      fish_user_key_bindings = ''
        ${pkgs.fzf}/bin/fzf --fish | source
      '';

      tmux-init = ''
        ${tmuxInitScript} $argv
      '';

      update_all = ''
        nix flake update ~/src/myconfigfiles/nixos-flake
        sudo nixos-rebuild switch --flake ~/src/myconfigfiles/nixos-flake#default
        home-manager generations >/dev/null 2>/dev/null
        fish_update_completions
        fc-cache -frv
      '';
    };
  };

  programs.tmux = {
    enable = true;
    extraConfig = tmuxConf;
  };

  home.file.".tmux.conf".text = tmuxConf;
}
