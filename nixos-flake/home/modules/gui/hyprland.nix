{
  pkgs,
  hyprlandMonitors,
  powermenuScript,
  ...
}:

let
  hyprlockConfig = pkgs.writeText "hyprlock.conf" ''
    background {
      monitor =
      path = ~/Pictures/background.jpg
      blur_passes = 2
      blur_size = 6
      color = rgba(29, 32, 33, 0.88)
    }

    general {
      grace = 2
      hide_cursor = true
      no_fade_in = false
    }

    input-field {
      monitor =
      size = 280, 56
      position = 0, -80
      halign = center
      valign = center

      outline_thickness = 2
      dots_size = 0.22
      dots_spacing = 0.18
      dots_center = true
      fade_on_empty = false
      placeholder_text = <span foreground="##d4be98">Password...</span>
      hide_input = false
      rounding = 8

      font_color = rgb(d4be98)
      inner_color = rgba(50, 48, 47, 0.85)
      outer_color = rgb(458588)
      check_color = rgb(a9b665)
      fail_color = rgb(ea6962)
      capslock_color = rgb(d8a657)
      both_color = rgb(d3869b)
    }

    label {
      monitor =
      text = cmd[update:1000] echo "$(date +"%H:%M")"
      color = rgb(d4be98)
      font_size = 72
      font_family = JetBrainsMono Nerd Font
      position = 0, 140
      halign = center
      valign = center
    }

    label {
      monitor =
      text = cmd[update:1000] echo "$(date +"%A, %B %d")"
      color = rgb(a89984)
      font_size = 20
      font_family = JetBrainsMono Nerd Font
      position = 0, 80
      halign = center
      valign = center
    }
  '';
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;

    settings = {
      monitor = hyprlandMonitors;

      exec-once = [
        "dbus-update-activation-environment --systemd --all"
        "gnome-keyring-daemon --start --components=secrets,ssh,pkcs11"
        "swaybg -i ~/Pictures/background.jpg -m fill"
        "swayosd-server"
        "dunst"
        "nm-applet --indicator"
        "blueman-applet"
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        "systemctl --user import-environment $(env | cut -d'=' -f 1)"
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
        layout = "scrolling";
      };

      animations = {
        enabled = 0;
      };

      misc = {
        force_default_wallpaper = 0;
      };

      "$mainMod" = "SUPER";
      "$term" = "alacritty";
      "$menu" = "rofi -show drun -show-icons";
      "$screenshotMenu" = "rofi -show screenshot";
      "$powerMenu" = "${powermenuScript}";
      "$calcMenu" = "rofi -show calc";

      bind = [
        "$mainMod, Return, exec, $term"
        "$mainMod SHIFT, Q, killactive,"
        "$mainMod SHIFT, X, exec, systemctl suspend"
        "$mainMod, Space, exec, $menu"
        "$mainMod, S, exec, $screenshotMenu"
        "$mainMod, C, exec, $calcMenu"
        "$mainMod, Escape, exec, $powerMenu"

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
        "$mainMod, period, layoutmsg, move +col"
        "$mainMod, comma, layoutmsg, move -col"
        "$mainMod SHIFT, period, layoutmsg, swapcol r"
        "$mainMod SHIFT, comma, layoutmsg, swapcol l"
        "$mainMod CTRL, period, layoutmsg, colresize +conf"
        "$mainMod CTRL, comma, layoutmsg, colresize -conf"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      submap = "reset";
    };

    extraConfig = ''
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
      windowrule = tag +floating-window, match:title ^(Select what to share)$
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
  _module.args = {
    inherit hyprlockConfig;
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "${pkgs.hyprlock}/bin/hyprlock --config ${hyprlockConfig}";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 3600;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 7200;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
}
