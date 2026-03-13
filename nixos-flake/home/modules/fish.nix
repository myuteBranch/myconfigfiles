{ pkgs, ... }:

let
  tmuxInitScript = pkgs.writeShellScript "tmux-init" ''
    exec sh "$HOME/src/myconfigfiles/scripts/tmux_session.sh" "$@"
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
}
