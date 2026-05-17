{
  config,
  lib,
  pkgs,
  monitors,
  powermenuScript,
  ...
}:

let
  lua = lib.generators.mkLuaInline;

  bind = key: dispatcher: {
    _args = [
      key
      (lua dispatcher)
    ];
  };

  bindWithOpts = key: dispatcher: opts: {
    _args = [
      key
      (lua dispatcher)
      opts
    ];
  };

  windowRule = rule: rule;

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
      font_family = CaskaydiaMono Nerd Font
      position = 0, 140
      halign = center
      valign = center
    }

    label {
      monitor =
      text = cmd[update:1000] echo "$(date +"%A, %B %d")"
      color = rgb(a89984)
      font_size = 20
      font_family = CaskaydiaMono Nerd Font
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
    configType = "lua";

    settings = {
      monitor = map (monitor: {
        output = monitor.name;
        mode = monitor.resolution;
        position = monitor.position;
        scale = toString monitor.scale;
      }) monitors;

      config = {
        input = {
          kb_layout = "us, us";
          kb_variant = "dvorak,";
          kb_options = "grp:alt_shift_toggle";
          follow_mouse = 1;
          sensitivity = -0.5;

          touchpad = {
            natural_scroll = true;
          };
        };

        general = {
          gaps_in = 2;
          gaps_out = 5;
          border_size = 2;
          col = {
            active_border = "rgba(458588ff)";
            inactive_border = "rgba(3c3836ff)";
          };
          layout = "scrolling";
        };

        animations = {
          enabled = false;
        };

        misc = {
          force_default_wallpaper = 0;
        };

        xwayland = {
          force_zero_scaling = true;
        };

        ecosystem = {
          no_update_news = true;
        };
      };

      on = {
        _args = [
          "hyprland.start"
          (lua ''
            function()
              hl.exec_cmd("dbus-update-activation-environment --systemd --all")
              hl.exec_cmd("gnome-keyring-daemon --start --components=secrets,ssh,pkcs11")
              hl.exec_cmd("swaybg -i ~/Pictures/background.jpg -m fill")
              hl.exec_cmd("swayosd-server")
              hl.exec_cmd("dunst")
              hl.exec_cmd("nm-applet --indicator")
              hl.exec_cmd("blueman-applet")
              hl.exec_cmd("${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1")
              hl.exec_cmd("systemctl --user import-environment $(env | cut -d'=' -f 1)")
              hl.exec_cmd("systemctl --user restart ashell")
              hl.exec_cmd("vivaldi-share", { workspace = "1 silent" })
              hl.exec_cmd("alacritty", { workspace = "2 silent" })
              hl.exec_cmd("steam", { workspace = "4 silent" })
            end
          '')
        ];
      };

      bind = [
        (bind "SUPER + Return" ''hl.dsp.exec_cmd("alacritty")'')
        (bind "SUPER + SHIFT + Q" "hl.dsp.window.close()")
        (bind "SUPER + SHIFT + X" ''hl.dsp.exec_cmd("systemctl suspend")'')
        (bind "SUPER + Space" ''hl.dsp.exec_cmd("rofi -show drun -show-icons")'')
        (bind "SUPER + S" ''hl.dsp.exec_cmd("rofi -show screenshot")'')
        (bind "SUPER + C" ''hl.dsp.exec_cmd("rofi -show calc")'')
        (bind "SUPER + Escape" ''hl.dsp.exec_cmd("${powermenuScript}")'')

        (bind "SUPER + H" ''hl.dsp.focus({ direction = "left" })'')
        (bind "SUPER + L" ''hl.dsp.focus({ direction = "right" })'')
        (bind "SUPER + K" ''hl.dsp.focus({ direction = "up" })'')
        (bind "SUPER + J" ''hl.dsp.focus({ direction = "down" })'')
        (bind "SUPER + Left" ''hl.dsp.focus({ direction = "left" })'')
        (bind "SUPER + Right" ''hl.dsp.focus({ direction = "right" })'')
        (bind "SUPER + Up" ''hl.dsp.focus({ direction = "up" })'')
        (bind "SUPER + Down" ''hl.dsp.focus({ direction = "down" })'')

        (bind "SUPER + SHIFT + H" ''hl.dsp.window.move({ direction = "left" })'')
        (bind "SUPER + SHIFT + L" ''hl.dsp.window.move({ direction = "right" })'')
        (bind "SUPER + SHIFT + K" ''hl.dsp.window.move({ direction = "up" })'')
        (bind "SUPER + SHIFT + J" ''hl.dsp.window.move({ direction = "down" })'')
        (bind "SUPER + SHIFT + Left" ''hl.dsp.window.move({ direction = "left" })'')
        (bind "SUPER + SHIFT + Right" ''hl.dsp.window.move({ direction = "right" })'')
        (bind "SUPER + SHIFT + Up" ''hl.dsp.window.move({ direction = "up" })'')
        (bind "SUPER + SHIFT + Down" ''hl.dsp.window.move({ direction = "down" })'')

        (bind "SUPER + SHIFT + V" ''hl.dsp.layout("togglesplit")'')
        (bind "SUPER + E" ''hl.dsp.layout("togglesplit")'')
        (bind "SUPER + SHIFT + Space" "hl.dsp.window.float()")
        (bind "SUPER + F" ''hl.dsp.window.fullscreen({ mode = "fullscreen" })'')

        (bind "SUPER + 1" ''hl.dsp.focus({ workspace = "1" })'')
        (bind "SUPER + 2" ''hl.dsp.focus({ workspace = "2" })'')
        (bind "SUPER + 3" ''hl.dsp.focus({ workspace = "3" })'')
        (bind "SUPER + 4" ''hl.dsp.focus({ workspace = "4" })'')
        (bind "SUPER + 5" ''hl.dsp.focus({ workspace = "5" })'')
        (bind "SUPER + 6" ''hl.dsp.focus({ workspace = "6" })'')
        (bind "SUPER + 7" ''hl.dsp.focus({ workspace = "7" })'')
        (bind "SUPER + 8" ''hl.dsp.focus({ workspace = "8" })'')
        (bind "SUPER + 9" ''hl.dsp.focus({ workspace = "9" })'')
        (bind "SUPER + 0" ''hl.dsp.focus({ workspace = "10" })'')

        (bind "SUPER + SHIFT + 1" ''hl.dsp.window.move({ workspace = "1" })'')
        (bind "SUPER + SHIFT + 2" ''hl.dsp.window.move({ workspace = "2" })'')
        (bind "SUPER + SHIFT + 3" ''hl.dsp.window.move({ workspace = "3" })'')
        (bind "SUPER + SHIFT + 4" ''hl.dsp.window.move({ workspace = "4" })'')
        (bind "SUPER + SHIFT + 5" ''hl.dsp.window.move({ workspace = "5" })'')
        (bind "SUPER + SHIFT + 6" ''hl.dsp.window.move({ workspace = "6" })'')
        (bind "SUPER + SHIFT + 7" ''hl.dsp.window.move({ workspace = "7" })'')
        (bind "SUPER + SHIFT + 8" ''hl.dsp.window.move({ workspace = "8" })'')
        (bind "SUPER + SHIFT + 9" ''hl.dsp.window.move({ workspace = "9" })'')
        (bind "SUPER + SHIFT + 0" ''hl.dsp.window.move({ workspace = "10" })'')

        (bind "SUPER + mouse_down" ''hl.dsp.focus({ workspace = "e+1" })'')
        (bind "SUPER + mouse_up" ''hl.dsp.focus({ workspace = "e-1" })'')

        (bind "SUPER + SHIFT + C" ''hl.dsp.exec_cmd("hyprctl reload")'')
        (bind "SUPER + SHIFT + E" "hl.dsp.exit()")
        (bind "SUPER + period" ''hl.dsp.layout("move +col")'')
        (bind "SUPER + comma" ''hl.dsp.layout("move -col")'')
        (bind "SUPER + CTRL + period" ''hl.dsp.layout("colresize +conf")'')
        (bind "SUPER + CTRL + comma" ''hl.dsp.layout("colresize -conf")'')
        (bind "SUPER + SHIFT + period" ''hl.dsp.layout("swapcol r")'')
        (bind "SUPER + SHIFT + comma" ''hl.dsp.layout("swapcol l")'')
        (bind "SUPER + CTRL + Right" ''hl.dsp.exec_raw("hyprctl --batch \"dispatch movewindow r ; dispatch movewindow u\"")'')
        (bind "SUPER + CTRL + Left" ''hl.dsp.exec_raw("hyprctl --batch \"dispatch movewindow l ; dispatch movewindow d\"")'')
        (bind "SUPER + CTRL + P" ''hl.dsp.layout("promote")'')

        (bindWithOpts "SUPER + mouse:272" "hl.dsp.window.drag()" { mouse = true; })
        (bindWithOpts "SUPER + mouse:273" "hl.dsp.window.resize()" { mouse = true; })
      ];

      window_rule = [
        (windowRule {
          name = "steam-float";
          match.class = "steam";
          float = true;
        })
        (windowRule {
          name = "steam-center";
          match = {
            class = "steam";
            title = "Steam";
          };
          center = true;
        })
        (windowRule {
          name = "steam-remove-default-opacity";
          match.class = "steam.*";
          tag = "-default-opacity";
        })
        (windowRule {
          name = "steam-opacity";
          match.class = "steam.*";
          opacity = "1 1";
        })
        (windowRule {
          name = "steam-size";
          match = {
            class = "steam";
            title = "Steam";
          };
          size = "1280 720";
        })
        (windowRule {
          name = "steam-friends-size";
          match = {
            class = "steam";
            title = "Friends List";
          };
          size = "460 800";
        })
        (windowRule {
          name = "steam-idle-inhibit";
          match.class = "steam";
          idle_inhibit = "fullscreen";
        })

        (windowRule {
          name = "bitwarden-no-screen-share";
          match.class = "^(Bitwarden)$";
          no_screen_share = true;
        })
        (windowRule {
          name = "bitwarden-floating-tag";
          match.class = "^(Bitwarden)$";
          tag = "+floating-window";
        })

        (windowRule {
          name = "floating-window-float";
          match.tag = "floating-window";
          float = true;
        })
        (windowRule {
          name = "floating-window-center";
          match.tag = "floating-window";
          center = true;
        })
        (windowRule {
          name = "floating-window-size";
          match.tag = "floating-window";
          size = "1280 720";
        })

        (windowRule {
          name = "file-dialogs-floating-tag";
          match = {
            class = "(xdg-desktop-portal-gtk|sublime_text|DesktopEditors|org.gnome.Nautilus)";
            title = "^(Open.*Files?|Open [F|f]older.*|Save.*Files?|Save.*As|Save|All Files|.*wants to [open|save].*|[C|c]hoose.*)";
          };
          tag = "+floating-window";
        })
        (windowRule {
          name = "share-dialog-floating-tag";
          match.title = "^(Select what to share)$";
          tag = "+floating-window";
        })
        (windowRule {
          name = "zoom-floating-tag";
          match.class = "zoom";
          tag = "+floating-window";
        })
        (windowRule {
          name = "calculator-float";
          match.class = "org.gnome.Calculator";
          float = true;
        })

        (windowRule {
          name = "media-remove-default-opacity";
          match.class = "^(zoom|vlc|mpv|org.kde.kdenlive|com.obsproject.Studio|com.github.PintaProject.Pinta|imv|org.gnome.NautilusPreviewer)$";
          tag = "-default-opacity";
        })
        (windowRule {
          name = "media-opacity";
          match.class = "^(zoom|vlc|mpv|org.kde.kdenlive|com.obsproject.Studio|com.github.PintaProject.Pinta|imv|org.gnome.NautilusPreviewer)$";
          opacity = "1 1";
        })

        (windowRule {
          name = "pop-rounding";
          match.tag = "pop";
          rounding = 8;
        })
        (windowRule {
          name = "noidle-idle-inhibit";
          match.tag = "noidle";
          idle_inhibit = "always";
        })

        (windowRule {
          name = "pip-tag";
          match.title = "(Picture.?in.?[Pp]icture)";
          tag = "+pip";
        })
        (windowRule {
          name = "pip-remove-default-opacity";
          match.tag = "pip";
          tag = "-default-opacity";
        })
        (windowRule {
          name = "pip-float";
          match.tag = "pip";
          float = true;
        })
        (windowRule {
          name = "pip-pin";
          match.tag = "pip";
          pin = true;
        })
        (windowRule {
          name = "pip-size";
          match.tag = "pip";
          size = "600 338";
        })
        (windowRule {
          name = "pip-keep-aspect";
          match.tag = "pip";
          keep_aspect_ratio = true;
        })
        (windowRule {
          name = "pip-no-border";
          match.tag = "pip";
          border_size = 0;
        })
        (windowRule {
          name = "pip-opacity";
          match.tag = "pip";
          opacity = "1 1";
        })
        (windowRule {
          name = "pip-move";
          match.tag = "pip";
          move = "(monitor_w-window_w-40) (monitor_h*0.04)";
        })

        (windowRule {
          name = "chromium-browser-tag";
          match.class = "((google-)?[cC]hrom(e|ium)|[bB]rave-browser|[mM]icrosoft-edge|[vV]ivaldi-stable|helium)";
          tag = "+chromium-based-browser";
        })
        (windowRule {
          name = "firefox-browser-tag";
          match.class = "([fF]irefox|zen|librewolf)";
          tag = "+firefox-based-browser";
        })
        (windowRule {
          name = "chromium-remove-default-opacity";
          match.tag = "chromium-based-browser";
          tag = "-default-opacity";
        })
        (windowRule {
          name = "firefox-remove-default-opacity";
          match.tag = "firefox-based-browser";
          tag = "-default-opacity";
        })

        (windowRule {
          name = "video-app-remove-chromium-tag";
          match.class = "(chrome-youtube.com__-Default|chrome-app.zoom.us__wc_home-Default)";
          tag = "-chromium-based-browser";
        })
        (windowRule {
          name = "video-app-remove-default-opacity";
          match.class = "(chrome-youtube.com__-Default|chrome-app.zoom.us__wc_home-Default)";
          tag = "-default-opacity";
        })

        (windowRule {
          name = "chromium-browser-tile";
          match.tag = "chromium-based-browser";
          tile = true;
        })
        (windowRule {
          name = "chromium-browser-opacity";
          match.tag = "chromium-based-browser";
          opacity = "1.0 0.97";
        })
        (windowRule {
          name = "firefox-browser-opacity";
          match.tag = "firefox-based-browser";
          opacity = "1.0 0.97";
        })

        (windowRule {
          name = "xwayland-drag-fix";
          match = {
            class = "^$";
            title = "^$";
            xwayland = true;
            float = true;
            fullscreen = false;
            pin = false;
          };
          no_focus = true;
        })
      ];
    };
  };

  home.activation.removeLegacyHyprlandConf = lib.hm.dag.entryAfter [ "onFilesChange" ] ''
    rm -f ${config.home.homeDirectory}/.config/hypr/hyprland.conf
  '';

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
