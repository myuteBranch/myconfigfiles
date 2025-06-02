# modules/home/youruser.nix
{ config, pkgs, lib, ... }:

let
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz;
in
{
  imports =
    [
      (import "${home-manager}/nixos")
    ];

  users.users.myute.isNormalUser = true;
  programs.fish.enable = true;
  users.users.myute.shell = pkgs.fish;
  users.users.myute.useDefaultShell = true;
  home-manager.users.myute = { pkgs, ... }: {
    # Define user-specific packages (not strictly related to shell, but good to have)
    home.packages = with pkgs; [
      fzf # A popular command-line fuzzy finder
      eza # A modern replacement for 'ls'
      ripgrep # A line-oriented search tool that recursively searches the current directory for a regex pattern
    ];

    # --- Fish Shell Configuration ---
    programs.fish = {
      enable = true;

      # Custom Fish shell configuration (rc.fish)
      # The content here will be written to ~/.config/fish/config.fish
      shellInit = ''
        # Example: set a prompt character based on user
        # if status is-root
        #   set -g fish_prompt_pwd_dir_length 0
        #   set -g fish_prompt_host_color red
        #   set -g fish_prompt_symbol '#'
        # else
        #   set -g fish_prompt_symbol '>'
        # end

        # Auto-set PATH for local binaries
        # This is often handled by home-manager, but can be useful for manual additions.
        # set -gx PATH "$HOME/.local/bin" $PATH
        set -U fish_user_paths $HOME/.cargo/bin
	      abbr l eza -la
	      abbr ls eza -la --icons
        starship init fish | source
      '';
    };
    # --- Starship Prompt Configuration ---
    programs.starship = {
      enable = true;
      # Set starship to be loaded by fish.
      # Home Manager handles inserting `starship init fish | source` into your shell configuration.
      enableFishIntegration = true;

      # Starship configuration as a TOML string
      # This is a basic example; customize it to your liking.
      # You can find many options at https://starship.rs/config/
      settings = {
        format = "$directory$git_branch$git_status$cmd_duration$character";

        # Example modules to enable/disable or configure
        add_newline = true;
        aws.disabled = true;
        gcloud.disabled = true;
        kubernetes.disabled = true;
        sudo.disabled = false; # Show an indicator when sudo is active

        # Custom character for the prompt
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[✗](bold red)";
        };

        # Directory module (customize symbol, color, etc.)
        directory = {
          truncation_length = 3; # Truncate to 3 components
          truncate_to_repo = true; # Always truncate to the git repo root
          fish_style_paths = true; # Use fish-style path formatting
          format = "[$path]($style)[$read_only]($read_only_style) ";
        };

        # Git branch module
        git_branch = {
          symbol = " "; # Nerd Font git branch symbol
          truncation_length = 20;
        };

        # Command duration module
        cmd_duration = {
          min_time = 500; # Show only if command took > 500ms
          format = " took [$duration]($style)";
        };

        # Rust specific module
        rust = {
          symbol = "🦀 ";
        };

        # Go specific module
        golang = {
          symbol = "🐿️ ";
        };
      };
    };
  
    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "25.05";
  };
}

