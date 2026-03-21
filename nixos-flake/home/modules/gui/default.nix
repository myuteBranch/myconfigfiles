{
  pkgs,
  hyprlockConfig ? null,
  monitors ? [
    {
      name = "DP-1";
      resolution = "preferred";
      position = "auto";
      scale = 1;
    }
    {
      name = "HDMI-A-2";
      resolution = "preferred";
      position = "auto";
      scale = 1;
    }
  ],
  networkInterface ? "eno1",
  ...
}:

let
  hyprlandMonitors = map (
    monitor: "${monitor.name}, ${monitor.resolution}, ${monitor.position}, ${toString monitor.scale}"
  ) monitors;

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
        ${pkgs.hyprlock}/bin/hyprlock ${
          if hyprlockConfig != null then "--config ${hyprlockConfig}" else ""
        }
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
  imports = [
    ./alacritty.nix
    ./rofi.nix
    ./dunst.nix
    ./waybar.nix
    ./hyprland.nix
    ./hypr-env.nix
    ./systemd-user-env.nix
  ];

  home.packages = with pkgs; [
    pavucontrol
    nautilus
    blueman
    swaybg
    swayosd
    wl-clipboard
    libnotify
  ];

  home.sessionVariables = { };

  _module.args = {
    inherit
      hyprlandMonitors
      monitors
      networkInterface
      powermenuScript
      ;
  };
}
