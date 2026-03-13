{ pkgs, ... }:

let
  powermenuScript = pkgs.writeShellScript "waybar-powermenu" ''
    lock=" Lock"
    logout=" Logout"
    shutdown=" Shutdown"
    reboot=" Reboot"
    sleep=" Sleep"

    confirm_exit() {
      printf "no\nyes\n" | ${pkgs.rofi-wayland}/bin/rofi \
        -dmenu \
        -i \
        -p "Are you sure?" \
        -theme-str 'window { width: 20%; }' \
        -theme-str 'listview { lines: 2; }'
    }

    chosen=$(
      printf "%s\n%s\n%s\n%s\n%s" \
        "$lock" \
        "$logout" \
        "$sleep" \
        "$reboot" \
        "$shutdown" \
      | ${pkgs.rofi-wayland}/bin/rofi \
          -dmenu \
          -i \
          -p "Power Menu" \
          -theme-str 'window { width: 20%; }' \
          -theme-str 'listview { lines: 5; }'
    )

    case "$chosen" in
      "$shutdown")
        ans="$(confirm_exit)"
        if [ "$ans" = "yes" ]; then
          systemctl poweroff
        fi
        ;;
      "$reboot")
        ans="$(confirm_exit)"
        if [ "$ans" = "yes" ]; then
          systemctl reboot
        fi
        ;;
      "$lock")
        ${pkgs.swaylock}/bin/swaylock -c 000000
        ;;
      "$logout")
        ans="$(confirm_exit)"
        if [ "$ans" = "yes" ]; then
          ${pkgs.hyprland}/bin/hyprctl dispatch exit
        fi
        ;;
      "$sleep")
        systemctl suspend
        ;;
    esac
  '';
in
{
  home.packages = with pkgs; [
    pavucontrol
    nautilus
    blueman
    swaybg
    swayosd
    wl-clipboard
    libnotify
  ];

  programs.alacritty = {
    enable = true;
    settings = {
      colors = {
        primary = {
          background = "0x1d2021";
          foreground = "0xd4be98";
        };

        normal = {
          black = "0x32302f";
          red = "0xea6962";
          green = "0xa9b665";
          yellow = "0xd8a657";
          blue = "0x7daea3";
          magenta = "0xd3869b";
          cyan = "0x89b482";
          white = "0xd4be98";
        };

        bright = {
          black = "0x32302f";
          red = "0xea6962";
          green = "0xa9b665";
          yellow = "0xd8a657";
          blue = "0x7daea3";
          magenta = "0xd3869b";
          cyan = "0x89b482";
          white = "0xd4be98";
        };

        cursor.cursor = "0xec5d2a";
      };

      env.TERM = "xterm-256color";

      font = {
        size = 9.0;
        normal = {
          family = "MesloLGM Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "MesloLGM Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "MesloLGM Nerd Font";
          style = "Italic";
        };
        bold_italic = {
          family = "MesloLGM Nerd Font";
          style = "Bold Italic";
        };
        offset = {
          x = 1;
          y = 1;
        };
      };

      keyboard.bindings = [
        { action = "Paste"; key = "V"; mods = "Control|Shift"; }
        { action = "Copy"; key = "C"; mods = "Control|Shift"; }
        { action = "PasteSelection"; key = "Insert"; mods = "Shift"; }
        { action = "ResetFontSize"; key = "Key0"; mods = "Control"; }
        { action = "IncreaseFontSize"; key = "Equals"; mods = "Control"; }
        { action = "IncreaseFontSize"; key = "ZoomIn"; mods = "Control"; }
        { action = "DecreaseFontSize"; key = "ZoomOut"; mods = "Control"; }
        { action = "DecreaseFontSize"; key = "Minus"; mods = "Control"; }
        { action = "Paste"; key = "Paste"; }
        { action = "Copy"; key = "Copy"; }
        { action = "ClearLogNotice"; key = "L"; mods = "Control"; }
        { chars = "\\f"; key = "L"; mods = "Control"; }
        { action = "ScrollPageUp"; key = "PageUp"; mode = "~Alt"; mods = "Shift"; }
        { action = "ScrollPageDown"; key = "PageDown"; mode = "~Alt"; mods = "Shift"; }
        { action = "ScrollToTop"; key = "Home"; mode = "~Alt"; mods = "Shift"; }
        { action = "ScrollToBottom"; key = "End"; mode = "~Alt"; mods = "Shift"; }
      ];

      scrolling.history = 5000;

      window = {
        title = "Alacritty";
        opacity = 0.95;
        class = {
          general = "Alacritty";
          instance = "Alacritty";
        };
        padding = {
          x = 6;
          y = 6;
        };
      };
    };
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    terminal = "alacritty";
    extraConfig = {
      modi = "drun,run,window";
      icon-theme = "Papirus";
      show-icons = true;
      drun-display-format = "{icon} {name}";
      location = 0;
      disable-history = false;
      hide-scrollbar = true;
      display-drun = " Apps";
      display-run = " Run";
      display-window = " Win";
      sidebar-mode = true;
      kb-row-down = "Down,Control+n";
      kb-row-up = "Up,Control+p";
      kb-mode-complete = "Control+Shift+Right";
      kb-mode-next = "Shift+Right,Control+l";
    };
    theme = ''
      @theme "/usr/share/rofi/themes/gruvbox-dark.rasi"
    '';
  };

  services.dunst = {
    enable = true;
    settings = {
      global = {
        monitor = 0;
        follow = "none";
        width = 300;
        height = "(0,300)";
        origin = "top-right";
        offset = "30x30";
        scale = 0;
        notification_limit = 20;
        progress_bar = true;
        progress_bar_height = 10;
        progress_bar_frame_width = 1;
        progress_bar_min_width = 150;
        progress_bar_max_width = 300;
        progress_bar_corner_radius = 10;
        icon_corner_radius = 0;
        indicate_hidden = "yes";
        transparency = 80;
        separator_height = 2;
        padding = 8;
        horizontal_padding = 8;
        text_icon_padding = 0;
        frame_width = 1;
        frame_color = "#ffffff";
        gap_size = 0;
        separator_color = "frame";
        sort = "yes";
        font = "DejaVuSansM Nerd Font 9";
        line_height = 1;
        markup = "full";
        format = "<b>%s</b>\\n%b";
        alignment = "left";
        vertical_alignment = "center";
        show_age_threshold = 60;
        ellipsize = "middle";
        ignore_newline = "no";
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = "yes";
        enable_recursive_icon_lookup = true;
        icon_theme = "Adwaita, breeze";
        icon_position = "left";
        min_icon_size = 32;
        max_icon_size = 128;
        icon_path = "/usr/share/icons/gnome/16x16/status/:/usr/share/icons/gnome/16x16/devices/";
        sticky_history = "yes";
        history_length = 20;
      };
    };
  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ''
      * {
          border: none;
          border-radius: 0;
          min-height: 0;
          font-family: "DejaVuSansM Nerd Font";
          font-weight: 500;
          font-size: 12px;
          padding: 0;
          opacity: 0.95;
      }

      window#waybar {
          background: #1d2021;
          border: 2px solid #3c3836;
      }

      tooltip {
          background-color: #1d2021;
          border: 2px solid #7c6f64;
      }

      #clock,
      #disk,
      #tray,
      #cpu,
      #memory,
      #battery,
      #network,
      #custom-powermenu,
      #pulseaudio {
          margin: 2px 2px 2px 0px;
          padding: 2px 8px;
      }

      #workspaces {
          background-color: #303536;
          margin: 2px 2px 2px 2px;
          border: 2px solid #434a4c;
      }

      #workspaces button {
          all: initial;
          min-width: 0;
          box-shadow: inset 0 -3px transparent;
          padding: 2px 4px;
          margin: 0px 2px 0px 0px;
          color: #c7ab7a;
      }

      #workspaces button.visible {
          color: #ddffa1;
      }

      #workspaces button.focused {
          color: #d4be98;
      }

      #workspaces button.urgent {
          background-color: #ff0000;
      }

      #clock {
          background-color: #303536;
          border: 2px solid #434a4c;
          color: #d4be98;
      }

      #tray {
          background-color: #d4be98;
          border: 2px solid #c7ab7a;
      }

      #battery {
          background-color: #a9b665;
          border: 2px solid #c7ab7a;
          color: #6c782e;
      }

      #cpu,
      #memory,
      #disk,
      #network,
      #powermenu,
      #pulseaudio {
          background-color: #ddc7a1;
          border: 2px solid #c7ab7a;
          color: #1d2021;
      }

      #cpu.critical,
      #memory.critical {
          background-color: #ddc7a1;
          border: 2px solid #c7ab7a;
          color: #c14a4a;
      }

      #battery.warning,
      #battery.critical,
      #battery.urgent {
          background-color: #ddc7a1;
          border: 2px solid #c7ab7a;
          color: #c14a4a;
      }
    '';

    settings = [
      {
        output = "DP-1";
        layer = "top";
        position = "top";
        height = 24;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [
          "cpu"
          "memory"
          "disk"
          "pulseaudio"
          "network"
          "custom/powermenu"
        ];

        "hyprland/workspaces" = {
          format = "{id}: {icon}";
          format-icons = {
            default = "";
            active = "";
            urgent = "";
          };
          persistent_workspaces."*" = 5;
          all-outputs = false;
        };

        clock = {
          format = " {:%A, %d %B %Y %H:%M}";
          tooltip-format = "<big>{:%Y-%m-%d %H:%M:%S}</big>";
          format-alt = " {:%Y-%m-%d %H:%M:%S}";
        };

        cpu = {
          format = "CPU {usage: >2}%";
          interval = 2;
        };

        memory = {
          format = "RAM {}%";
          interval = 2;
        };

        disk = {
          path = "/";
          format = " {path}: {percentage_used}%";
          interval = 25;
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = " muted";
          format-icons.default = [ "" "" "" ];
          scroll-step = 5;
          on-click = "pavucontrol";
        };

        network = {
          interface = "eno1";
          format-ethernet = " {bandwidthDownBytes}  {bandwidthUpBytes}";
          format-disconnected = "⚠ Disconnected";
          tooltip-format = "{ifname}: {ipaddr}/{cidr} ";
          tooltip-format-disconnected = "Disconnected";
          interval = 3;
        };

        "custom/powermenu" = {
          format = "";
          tooltip = true;
          tooltip-format = "Power Menu";
          on-click = "${powermenuScript} &";
        };
      }
      {
        output = "HDMI-A-2";
        layer = "top";
        position = "top";
        height = 24;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [
          "cpu"
          "memory"
          "disk"
          "keyboard-state"
          "pulseaudio"
          "network"
          "tray"
          "custom/powermenu"
        ];

        "hyprland/workspaces" = {
          format = "{id}: {icon}";
          format-icons = {
            default = "";
            active = "";
            urgent = "";
          };
          persistent_workspaces."*" = 5;
          all-outputs = false;
        };

        clock = {
          format = " {:%A, %d %B %Y %H:%M}";
          tooltip-format = "<big>{:%Y-%m-%d %H:%M:%S}</big>";
          format-alt = " {:%Y-%m-%d %H:%M:%S}";
        };

        cpu = {
          format = "CPU {usage: >2}%";
          interval = 2;
        };

        memory = {
          format = "RAM {}%";
          interval = 2;
        };

        disk = {
          path = "/";
          format = " {path}: {percentage_used}%";
          interval = 25;
        };

        "keyboard-state" = {
          numlock = true;
          capslock = true;
          format = "{name}";
          format-icons = {
            locked = "";
            unlocked = "";
          };
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = " muted";
          format-icons.default = [ "" "" "" ];
          scroll-step = 5;
          on-click = "pavucontrol";
        };

        network = {
          interface = "eno1";
          format-ethernet = " {bandwidthDownBytes}  {bandwidthUpBytes}";
          format-disconnected = "⚠ Disconnected";
          tooltip-format = "{ifname}: {ipaddr}/{cidr} ";
          tooltip-format-disconnected = "Disconnected";
          interval = 3;
        };

        tray = {
          icon-size = 16;
          spacing = 5;
        };

        "custom/powermenu" = {
          format = "";
          tooltip = true;
          tooltip-format = "Power Menu";
          on-click = "${powermenuScript} &";
        };
      }
    ];
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;

    extraConfig = ''
      # ~/.config/hypr/hyprland.conf

      # --- Monitors ---
      monitor = , preferred, auto, 1

      # --- Startup Applications ---
      exec-once = swaybg -i ~/Pictures/background.jpg -m fill
      exec-once = swayosd-server &
      exec-once = waybar &
      exec-once = dunst &
      exec-once = nm-applet --indicator &
      exec-once = blueman-applet &
      exec-once = ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1

      # Slow app launch fix -- set systemd vars
      exec-once = systemctl --user import-environment $(env | cut -d'=' -f 1)
      exec-once = dbus-update-activation-environment --systemd --all

      # --- Idle and Screen Locking ---
      exec-once = swayidle -w \
                  timeout 7200 '${pkgs.swaylock}/bin/swaylock -f -c 000000' \
                  timeout 3600 'hyprctl dispatch dpms off' \
                  resume 'hyprctl dispatch dpms on'

      # --- Include external configuration files ---
      source = ~/.config/hypr/env.conf

      # --- Input Configuration ---
      input {
          kb_layout = us, us
          kb_variant = dvorak,
          kb_model =
          kb_options = grp:alt_shift_toggle
          kb_rules =

          follow_mouse = 1

          touchpad {
              natural_scroll = yes
          }

          sensitivity = 0
      }

      # --- General Settings ---
      general {
          gaps_in = 2
          gaps_out = 5
          border_size = 2
          col.active_border = rgba(458588ff)
          col.inactive_border = rgba(3c3836ff)
          layout = dwindle
      }

      # --- Decoration ---
      decoration {
          rounding = 5

          blur {
              enabled = true
              size = 3
              passes = 1
          }
      }

      # --- Animations ---
      animations {
          enabled = 0

          bezier = myBezier, 0.05, 0.9, 0.1, 1.05

          animation = windows, 1, 7, myBezier
          animation = windowsOut, 1, 7, default, popin 80%
          animation = border, 1, 10, default
          animation = borderangle, 1, 8, default
          animation = fade, 1, 7, default
          animation = workspaces, 1, 6, default
      }

      # --- Layout Specifics ---
      dwindle {
          pseudotile = yes
          preserve_split = yes
      }

      master {
      }

      # --- Gestures ---
      gestures {
          workspace_swipe = off
      }

      # --- Miscellaneous ---
      misc {
          force_default_wallpaper = 0
      }

      # --- Variables ---
      $mainMod = SUPER
      $term = alacritty
      $menu = rofi -show drun -show-icons

      # --- Keybindings ---
      bind = $mainMod, Return, exec, $term
      bind = $mainMod SHIFT, Q, killactive,
      bind = $mainMod SHIFT, X, exec, systemctl suspend
      bind = $mainMod, Space, exec, $menu

      bind = $mainMod, H, movefocus, l
      bind = $mainMod, L, movefocus, r
      bind = $mainMod, K, movefocus, u
      bind = $mainMod, J, movefocus, d
      bind = $mainMod, Left, movefocus, l
      bind = $mainMod, Right, movefocus, r
      bind = $mainMod, Up, movefocus, u
      bind = $mainMod, Down, movefocus, d

      bind = $mainMod SHIFT, H, movewindow, l
      bind = $mainMod SHIFT, L, movewindow, r
      bind = $mainMod SHIFT, K, movewindow, u
      bind = $mainMod SHIFT, J, movewindow, d
      bind = $mainMod SHIFT, Left, movewindow, l
      bind = $mainMod SHIFT, Right, movewindow, r
      bind = $mainMod SHIFT, Up, movewindow, u
      bind = $mainMod SHIFT, Down, movewindow, d

      bind = $mainMod SHIFT, V, layoutmsg, togglesplit
      bind = $mainMod SHIFT, H, layoutmsg, togglesplit
      bind = $mainMod, E, layoutmsg, togglesplit
      bind = $mainMod SHIFT, Space, togglefloating,
      bind = $mainMod, F, fullscreen, 0

      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5
      bind = $mainMod, 6, workspace, 6
      bind = $mainMod, 7, workspace, 7
      bind = $mainMod, 8, workspace, 8
      bind = $mainMod, 9, workspace, 9
      bind = $mainMod, 0, workspace, 10

      bind = $mainMod SHIFT, 1, movetoworkspace, 1
      bind = $mainMod SHIFT, 2, movetoworkspace, 2
      bind = $mainMod SHIFT, 3, movetoworkspace, 3
      bind = $mainMod SHIFT, 4, movetoworkspace, 4
      bind = $mainMod SHIFT, 5, movetoworkspace, 5
      bind = $mainMod SHIFT, 6, movetoworkspace, 6
      bind = $mainMod SHIFT, 7, movetoworkspace, 7
      bind = $mainMod SHIFT, 8, movetoworkspace, 8
      bind = $mainMod SHIFT, 9, movetoworkspace, 9
      bind = $mainMod SHIFT, 0, movetoworkspace, 10

      bind = $mainMod, mouse_down, workspace, e+1
      bind = $mainMod, mouse_up, workspace, e-1

      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow

      bind = $mainMod SHIFT, C, exec, hyprctl reload
      bind = $mainMod SHIFT, E, exit,

      bind = $mainMod, R, submap, resize

      submap = resize
          binde = , l, resizeactive, 10 0
          binde = , h, resizeactive, -10 0
          binde = , k, resizeactive, 0 -10
          binde = , j, resizeactive, 0 10
          bind = , escape, submap, reset
      submap = reset
    '';
  };

  xdg.configFile."hypr/env.conf".text = ''
    env = XCURSOR_SIZE,24
    env = HYPRCURSOR_SIZE,24

    env = GDK_BACKEND,wayland,x11,*
    env = QT_QPA_PLATFORM,wayland;xcb
    env = QT_STYLE_OVERRIDE,kvantum
    env = SDL_VIDEODRIVER,wayland
    env = MOZ_ENABLE_WAYLAND,1
    env = ELECTRON_OZONE_PLATFORM_HINT,wayland
    env = OZONE_PLATFORM,wayland
    env = XDG_SESSION_TYPE,wayland

    env = XDG_CURRENT_DESKTOP,Hyprland
    env = XDG_SESSION_DESKTOP,Hyprland

    xwayland {
      force_zero_scaling = true
    }

    env = XCOMPOSEFILE,~/.XCompose

    ecosystem {
      no_update_news = true
    }
  '';
}
