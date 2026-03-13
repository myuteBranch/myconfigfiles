{ pkgs, monitors ? [ { name = "DP-1"; resolution = "preferred"; position = "auto"; scale = 1; } { name = "HDMI-A-2"; resolution = "preferred"; position = "auto"; scale = 1; } ], networkInterface ? "eno1", ... }:


let
  powermenuScript = pkgs.writeShellScript "waybar-powermenu" ''
    lock=" Lock"
    logout=" Logout"
    shutdown=" Shutdown"
    reboot=" Reboot"
    sleep=" Sleep"

    confirm_exit() {
      printf "no\nyes\n" | ${pkgs.rofi}/bin/rofi \
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
      | ${pkgs.rofi}/bin/rofi \
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

  hyprlandMonitors = map (
    monitor:
    "${monitor.name}, ${monitor.resolution}, ${monitor.position}, ${toString monitor.scale}"
  ) monitors;

  screenshotScript = pkgs.writeShellScript "rofi-screenshot" ''
    dir="$HOME/Pictures/Screenshots"
    mkdir -p "$dir"

    regioncb="󰹑 Screenshot Region to Clipboard"
    region="󰹑 Screenshot Region"

    chosen=$(
      printf "%s\n%s\n" "$regioncb" "$region" | ${pkgs.rofi}/bin/rofi \
        -dmenu \
        -i \
        -p "Screenshot" \
        -theme-str 'window { width: 20%; }' \
        -theme-str 'listview { lines: 2; }'
    )

    case "$chosen" in
      "$regioncb")
        ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.wl-clipboard}/bin/wl-copy
        ${pkgs.libnotify}/bin/notify-send "Screenshot copied" "$file"
        ;;
      "$region")
        file="$dir/$(date +'%Y-%m-%d_%H-%M-%S').png"
        ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" "$file"
        ${pkgs.wl-clipboard}/bin/wl-copy < "$file"
        ${pkgs.libnotify}/bin/notify-send "Screenshot saved" "$file"
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
    package = pkgs.rofi;
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
      display-screenshot = "󰹑 Shot";
      sidebar-mode = true;
      kb-row-down = "Down,Control+n";
      kb-row-up = "Up,Control+p";
      kb-mode-complete = "Control+Shift+Right";
      kb-mode-next = "Shift+Right,Control+l";
    };
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
        background-color: #2d353b;
        color: #d3c6aa;

        border: none;
        border-radius: 0;
        min-height: 0;
        font-family: 'JetBrainsMono Nerd Font Mono';
        font-size: 13px;
      }

      window#waybar{
          all:unset;
      }
      .modules-left {
          padding:7px;
          margin:10 0 5 10;
          border-radius:10px;
          background: alpha(@background,.6);
          box-shadow: 0px 0px 2px rgba(0, 0, 0, .6);
      }
      .modules-center {
          padding:7px;
          margin:10 0 5 0;
          border-radius:10px;
          background: alpha(@background,.6);
          box-shadow: 0px 0px 2px rgba(0, 0, 0, .6);
      }
      .modules-right {
          padding:7px;
          margin: 10 10 5 0;
          border-radius:10px;
          background: alpha(@background,.6);
          box-shadow: 0px 0px 2px rgba(0, 0, 0, .6);
      }
      tooltip {
          background:@background;
          color: @color7;
      }
      #clock:hover, #custom-pacman:hover, #custom-notification:hover,#bluetooth:hover,#network:hover,#battery:hover, #cpu:hover,#memory:hover,#temperature:hover{
          transition: all .3s ease;
          color:@color9;
      }
      #custom-notification {
          padding: 0px 5px;
          transition: all .3s ease;
          color:@color7;
      }
      #clock{
          padding: 0px 5px;
          color:@color7;
          transition: all .3s ease;
      }
      #custom-pacman{
          padding: 0px 5px;
          transition: all .3s ease;
          color:@color7;

      }
      #workspaces {
          padding: 0px 5px;
      }
      #workspaces button {
          all:unset;
          padding: 0px 5px;
          color: alpha(@color9,.4);
          transition: all .2s ease;
      }
      #workspaces button:hover {
          color:rgba(0,0,0,0);
          border: none;
          text-shadow: 0px 0px 1.5px rgba(0, 0, 0, .5);
          transition: all 1s ease;
      }
      #workspaces button.active {
          color: @color9;
          border: none;
          text-shadow: 0px 0px 2px rgba(0, 0, 0, .5);
      }
      #workspaces button.empty {
          color: rgba(0,0,0,0);
          border: none;
          text-shadow: 0px 0px 1.5px rgba(0, 0, 0, .2);
      }
      #workspaces button.empty:hover {
          color: rgba(0,0,0,0);
          border: none;
          text-shadow: 0px 0px 1.5px rgba(0, 0, 0, .5);
          transition: all 1s ease;
      }
      #workspaces button.empty.active {
          color: @color9;
          border: none;
          text-shadow: 0px 0px 2px rgba(0, 0, 0, .5);
      }
      #bluetooth{
          padding: 0px 5px;
          transition: all .3s ease;
          color:@color7;

      }
      #network{
          padding: 0px 5px;
          transition: all .3s ease;
          color:@color7;

      }
      #battery{
          padding: 0px 5px;
          transition: all .3s ease;
          color:@color7;


      }
      #battery.charging {
          color: #26A65B;
      }

      #battery.warning:not(.charging) {
          color: #ffbe61;
      }

      #battery.critical:not(.charging) {
          color: #f53c3c;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }
      #group-expand{
          padding: 0px 5px;
          transition: all .3s ease;
      }
      #custom-expand{
          padding: 0px 5px;
          color:alpha(@foreground,.2);
          text-shadow: 0px 0px 2px rgba(0, 0, 0, .7);
          transition: all .3s ease;
      }
      #custom-expand:hover{
          color:rgba(255,255,255,.2);
          text-shadow: 0px 0px 2px rgba(255, 255, 255, .5);
      }
      #custom-colorpicker{
          padding: 0px 5px;
      }
      #cpu,#memory,#temperature{
          padding: 0px 5px;
          transition: all .3s ease;
          color:@color7;

      }
      #custom-endpoint{
          color:transparent;
          text-shadow: 0px 0px 1.5px rgba(0, 0, 0, 1);

      }
      #tray{
          padding: 0px 5px;
          transition: all .3s ease;

      }
      #tray menu * {
          padding: 0px 5px;
          transition: all .3s ease;
      }

      #tray menu separator {
          padding: 0px 5px;
          transition: all .3s ease;
      }
    '';

    settings = [
      {
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
          "tray"
          "keyboard-state"
        ];

        "hyprland/workspaces" = {
          format = "{id}: {icon}";
          format-icons = {
            active = "";
            default = "";
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
          interface = networkInterface;
          format-ethernet = " {bandwidthDownBytes}  {bandwidthUpBytes}";
          format-disconnected = "⚠ Disconnected";
          tooltip-format = "{ifname}: {ipaddr}/{cidr} ";
          tooltip-format-disconnected = "Disconnected";
          interval = 3;
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
    settings = {
      monitor = hyprlandMonitors;

      exec-once = [
        "swaybg -i ~/Pictures/background.jpg -m fill"
        "swayosd-server"
        "dunst"
        "nm-applet --indicator"
        "blueman-applet"
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        "systemctl --user import-environment $(env | cut -d'=' -f 1)"
        "dbus-update-activation-environment --systemd --all"
        "swayidle -w timeout 7200 '${pkgs.swaylock}/bin/swaylock -f -c 000000' timeout 3600 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on'"
      ];

      source = [ "~/.config/hypr/env.conf" ];

      input = {
        kb_layout = "us, us";
        kb_variant = "dvorak,";
        kb_options = "grp:alt_shift_toggle";
        follow_mouse = 1;
        sensitivity = 0;

        touchpad = {
          natural_scroll = true;
        };
      };

      general = {
        gaps_in = 2;
        gaps_out = 5;
        border_size = 2;
        "col.active_border" = "rgba(458588ff)";
        "col.inactive_border" = "rgba(3c3836ff)";
        layout = "dwindle";
      };

      decoration = {
        rounding = 5;

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
      };

      animations = {
        enabled = 0;
        bezier = [ "myBezier, 0.05, 0.9, 0.1, 1.05" ];
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      misc = {
        force_default_wallpaper = 0;
      };

      "$mainMod" = "SUPER";
      "$term" = "alacritty";
      "$menu" = "rofi -show drun -show-icons";
      "$screenshotMenu" = "${screenshotScript}";

      bind = [
        "$mainMod, Return, exec, $term"
        "$mainMod SHIFT, Q, killactive,"
        "$mainMod SHIFT, X, exec, systemctl suspend"
        "$mainMod, Space, exec, $menu"
        "$mainMod, S, exec, $screenshotMenu"

        "$mainMod, H, movefocus, l"
        "$mainMod, L, movefocus, r"
        "$mainMod, K, movefocus, u"
        "$mainMod, J, movefocus, d"
        "$mainMod, Left, movefocus, l"
        "$mainMod, Right, movefocus, r"
        "$mainMod, Up, movefocus, u"
        "$mainMod, Down, movefocus, d"

        "$mainMod SHIFT, H, movewindow, l"
        "$mainMod SHIFT, L, movewindow, r"
        "$mainMod SHIFT, K, movewindow, u"
        "$mainMod SHIFT, J, movewindow, d"
        "$mainMod SHIFT, Left, movewindow, l"
        "$mainMod SHIFT, Right, movewindow, r"
        "$mainMod SHIFT, Up, movewindow, u"
        "$mainMod SHIFT, Down, movewindow, d"

        "$mainMod SHIFT, V, layoutmsg, togglesplit"
        "$mainMod, E, layoutmsg, togglesplit"
        "$mainMod SHIFT, Space, togglefloating,"
        "$mainMod, F, fullscreen, 0"

        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"

        "$mainMod SHIFT, C, exec, hyprctl reload"
        "$mainMod SHIFT, E, exit,"
        "$mainMod, R, submap, resize"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      submap = "reset";

      binde = [
        ", l, resizeactive, 10 0"
        ", h, resizeactive, -10 0"
        ", k, resizeactive, 0 -10"
        ", j, resizeactive, 0 10"
      ];

      bindl = [
        ", escape, submap, reset"
      ];
    };

    extraConfig = ''
      submap = resize
          binde = , l, resizeactive, 10 0
          binde = , h, resizeactive, -10 0
          binde = , k, resizeactive, 0 -10
          binde = , j, resizeactive, 0 10
          bind = , escape, submap, reset
      submap = reset

      windowrule = float on, match:class steam
      windowrule = center on, match:class steam, match:title Steam
      windowrule = tag -default-opacity, match:class steam.*
      windowrule = opacity 1 1, match:class steam.*
      windowrule = size 1100 700, match:class steam, match:title Steam
      windowrule = size 460 800, match:class steam, match:title Friends List
      windowrule = idle_inhibit fullscreen, match:class steam

      windowrule = no_screen_share on, match:class ^(Bitwarden)$
      windowrule = tag +floating-window, match:class ^(Bitwarden)$

      # Floating windows
      windowrule = float on, match:tag floating-window
      windowrule = center on, match:tag floating-window
      windowrule = size 875 600, match:tag floating-window

      windowrule = tag +floating-window, match:class (xdg-desktop-portal-gtk|sublime_text|DesktopEditors|org.gnome.Nautilus), match:title ^(Open.*Files?|Open [F|f]older.*|Save.*Files?|Save.*As|Save|All Files|.*wants to [open|save].*|[C|c]hoose.*)
      windowrule = float on, match:class org.gnome.Calculator

      # Fullscreen screensave      # No transparency on media windows
      windowrule = tag -default-opacity, match:class ^(zoom|vlc|mpv|org.kde.kdenlive|com.obsproject.Studio|com.github.PintaProject.Pinta|imv|org.gnome.NautilusPreviewer)$
      windowrule = opacity 1 1, match:class ^(zoom|vlc|mpv|org.kde.kdenlive|com.obsproject.Studio|com.github.PintaProject.Pinta|imv|org.gnome.NautilusPreviewer)$

      # Popped window rounding
      windowrule = rounding 8, match:tag pop

      # Prevent idle while open
      windowrule = idle_inhibit always, match:tag noidle

      # Browser types
      windowrule = tag +chromium-based-browser, match:class ((google-)?[cC]hrom(e|ium)|[bB]rave-browser|[mM]icrosoft-edge|Vivaldi-stable|helium)
      windowrule = tag +firefox-based-browser, match:class ([fF]irefox|zen|librewolf)
      windowrule = tag -default-opacity, match:tag chromium-based-browser
      windowrule = tag -default-opacity, match:tag firefox-based-browser

      # Video apps: remove chromium browser tag so they don't get opacity applied
      windowrule = tag -chromium-based-browser, match:class (chrome-youtube.com__-Default|chrome-app.zoom.us__wc_home-Default)
      windowrule = tag -default-opacity, match:class (chrome-youtube.com__-Default|chrome-app.zoom.us__wc_home-Default)

      # Force chromium-based browsers into a tile to deal with --app bug
      windowrule = tile on, match:tag chromium-based-browser

      # Only a subtle opacity change, but not for video sites
      windowrule = opacity 1.0 0.97, match:tag chromium-based-browser
      windowrule = opacity 1.0 0.97, match:tag firefox-based-browser
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
