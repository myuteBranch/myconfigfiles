{ pkgs, ... }:

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
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      aws.symbol = "  ";
      buf.symbol = " ";
      c.symbol = " ";
      conda.symbol = " ";
      crystal.symbol = " ";
      dart.symbol = " ";

      directory = {
        read_only = " 󰌾";
        truncation_length = 5;
        truncate_to_repo = true;
        format = "[$path]($style)[$read_only]($read_only_style) ";
        read_only_style = "red";
        style = "bold italic blue";
      };

      docker_context = {
        format = "[$context](blue bold)";
        symbol = " ";
      };

      elixir.symbol = " ";
      elm.symbol = " ";
      fennel.symbol = " ";
      fossil_branch.symbol = " ";
      git_branch.symbol = " ";
      golang.symbol = " ";
      guix_shell.symbol = " ";
      haskell.symbol = " ";
      haxe.symbol = " ";
      hg_branch.symbol = " ";

      hostname = {
        ssh_symbol = " ";
        ssh_only = false;
        format = "[$hostname](bold #ee00ff) [❯](bold green) ";
        trim_at = ".companyname.com";
        disabled = false;
      };

      java.symbol = " ";
      julia.symbol = " ";
      kotlin.symbol = " ";
      lua.symbol = " ";
      memory_usage.symbol = "󰍛 ";
      meson.symbol = "󰔷 ";
      nim.symbol = "󰆥 ";
      nix_shell.symbol = " ";
      nodejs.symbol = " ";
      ocaml.symbol = " ";

      os.symbols = {
        Alpaquita = " ";
        Alpine = " ";
        AlmaLinux = " ";
        Amazon = " ";
        Android = " ";
        Arch = " ";
        Artix = " ";
        CentOS = " ";
        Debian = " ";
        DragonFly = " ";
        Emscripten = " ";
        EndeavourOS = " ";
        Fedora = " ";
        FreeBSD = " ";
        Garuda = "󰛓 ";
        Gentoo = " ";
        HardenedBSD = "󰞌 ";
        Illumos = "󰈸 ";
        Kali = " ";
        Linux = " ";
        Mabox = " ";
        Macos = " ";
        Manjaro = " ";
        Mariner = " ";
        MidnightBSD = " ";
        Mint = " ";
        NetBSD = " ";
        NixOS = " ";
        OpenBSD = "󰈺 ";
        openSUSE = " ";
        OracleLinux = "󰌷 ";
        Pop = " ";
        Raspbian = " ";
        Redhat = " ";
        RedHatEnterprise = " ";
        RockyLinux = " ";
        Redox = "󰀘 ";
        Solus = "󰠳 ";
        SUSE = " ";
        Ubuntu = " ";
        Unknown = " ";
        Void = " ";
        Windows = "󰍲 ";
      };

      package.symbol = "󰏗 ";
      perl.symbol = " ";
      php.symbol = " ";
      pijul_channel.symbol = " ";
      python.symbol = " ";
      rlang.symbol = "󰟔 ";
      ruby.symbol = " ";
      rust.symbol = " ";
      scala.symbol = " ";
      swift.symbol = " ";
      zig.symbol = " ";

      username.disabled = false;

      cmd_duration = {
        min_time = 4;
        show_milliseconds = false;
        disabled = false;
        format = "[ $duration](bold yellow)";
        style = "bold italic blue";
      };

      kubernetes = {
        format = "on [☸ $context \\($namespace\\)](dimmed green) ";
        disabled = false;
        context_aliases = {
          "dev.local.cluster.k8s" = "dev";
          ".*/openshift-cluster/.*" = "openshift";
          "gke_.*_(?P<cluster>[\\w-]+)" = "gke-$cluster";
        };
      };

      helm.format = "[⎈ $version](bold white) ";
    };
  };
}
