{
  networkInterface ? "eno1",
  powermenuScript,
  ...
}:

{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ''
      * {
        border: none;
        border-radius: 0;
        min-height: 0;
        font-family: 'CaskaydiaMono Nerd Font';
        font-size: 12px;
      }

      window#waybar {
        all: unset;
        background: transparent;
        color: #d3c6aa;
      }

      .modules-left,
      .modules-center,
      .modules-right {
        padding: 4px 10px;
        border-radius: 12px;
        background: alpha(#2d353b, .88);
        box-shadow: 0px 2px 6px rgba(0, 0, 0, .28);
      }

      .modules-left {
        margin: 10 0 5 10;
      }

      .modules-center {
        margin: 10 0 5 0;
      }

      .modules-right {
        margin: 10 10 5 0;
      }

      tooltip {
        background: #2d353b;
        color: #d3c6aa;
        border-radius: 8px;
        border: 1px solid alpha(#d3c6aa, .08);
      }

      #clock,
      #custom-pacman,
      #custom-notification,
      #bluetooth,
      #network,
      #battery,
      #cpu,
      #memory,
      #temperature,
      #pulseaudio,
      #disk,
      #tray,
      #custom-powermenu {
        padding: 0px 7px;
        color: @color7;
        border-radius: 8px;
        transition: color .2s ease, background-color .2s ease, box-shadow .2s ease;
      }

      #clock:hover,
      #custom-pacman:hover,
      #custom-notification:hover,
      #bluetooth:hover,
      #network:hover,
      #battery:hover,
      #cpu:hover,
      #memory:hover,
      #temperature:hover,
      #pulseaudio:hover,
      #disk:hover,
      #custom-powermenu:hover {
        color: @color9;
        background-color: alpha(@color9, .08);
      }

      #network {
        color: #bf9a06;
      }

      #battery.charging {
        color: #26A65B;
      }

      #battery.warning:not(.charging) {
        color: #ffbe61;
      }

      #workspaces {
        padding: 0px 2px;
      }

      #workspaces button {
        min-width: 28px;
        padding: 2px 10px;
        margin: 0px 3px;
        color: alpha(@color9, .5);
        background: transparent;
        border-radius: 10px;
        box-shadow: inset 0 0 0 1px transparent;
        text-shadow: none;
        transition: color .2s ease, background-color .2s ease, box-shadow .2s ease, transform .2s ease;
      }

      #workspaces button:hover {
        color: @color9;
        background-color: alpha(@color9, .10);
        box-shadow: inset 0 0 0 1px alpha(@color9, .10);
      }

      #workspaces button.active {
        color: @color9;
        background-color: alpha(@color9, .18);
        box-shadow: inset 0 0 0 1px alpha(@color9, .22);
      }

      #workspaces button.empty {
        color: alpha(@color9, .22);
        background: transparent;
        box-shadow: inset 0 0 0 1px transparent;
      }

      #workspaces button.empty:hover {
        color: alpha(@color9, .42);
        background-color: alpha(@color9, .06);
        box-shadow: inset 0 0 0 1px alpha(@color9, .06);
      }

      #workspaces button.empty.active {
        color: @color9;
        background-color: alpha(@color9, .18);
        box-shadow: inset 0 0 0 1px alpha(@color9, .22);
      }

      #workspaces button.urgent:not(.active) {
        color: #ffffff;
        background: linear-gradient(180deg, rgba(245, 60, 60, .96), rgba(210, 48, 48, .92));
        box-shadow:
          inset 0 0 0 1px rgba(255, 255, 255, .12),
          0 0 0 1px rgba(245, 60, 60, .18);
        animation-name: urgent-blink;
        animation-duration: 0.9s;
        animation-timing-function: ease-in-out;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

      #workspaces button.urgent:not(.active):hover {
        color: #ffffff;
      }

      @keyframes urgent-blink {
        from {
          background: linear-gradient(180deg, rgba(245, 60, 60, .96), rgba(210, 48, 48, .92));
          box-shadow:
            inset 0 0 0 1px rgba(255, 255, 255, .12),
            0 0 0 1px rgba(245, 60, 60, .18);
        }

        to {
          background: linear-gradient(180deg, rgba(245, 60, 60, .52), rgba(210, 48, 48, .46));
          box-shadow:
            inset 0 0 0 1px rgba(245, 60, 60, .12),
            0 0 8px rgba(245, 60, 60, .22);
        }
      }

      #battery.critical:not(.charging) {
        color: #f53c3c;
        animation-name: battery-blink;
        animation-duration: 0.8s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

      @keyframes battery-blink {
        to {
          color: #d3c6aa;
        }
      }

      #group-expand {
        padding: 0px 5px;
        transition: all .3s ease;
      }

      #custom-expand {
        padding: 0px 5px;
        color: alpha(@foreground, .2);
        text-shadow: 0px 0px 2px rgba(0, 0, 0, .7);
        transition: all .3s ease;
      }

      #custom-expand:hover {
        color: rgba(255, 255, 255, .2);
        text-shadow: 0px 0px 2px rgba(255, 255, 255, .5);
      }

      #custom-colorpicker {
        padding: 0px 5px;
      }

      #custom-endpoint {
        color: transparent;
        text-shadow: 0px 0px 1.5px rgba(0, 0, 0, 1);
      }

      #tray menu * {
        padding: 2px 6px;
        transition: all .2s ease;
      }

      #tray menu separator {
        padding: 1px 5px;
        transition: all .2s ease;
      }
    '';

    settings = [
      {
        layer = "top";
        position = "top";
        height = 12;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [
          "cpu"
          "memory"
          "disk"
          "tray"
          "network"
          "pulseaudio"
          "custom/powermenu"
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
          format-icons.default = [
            ""
            ""
            ""
          ];
          scroll-step = 5;
          on-click = "pavucontrol";
        };

        network = {
          interface = networkInterface;
          format-ethernet = " {bandwidthDownBytes}  {bandwidthUpBytes}";
          format-wifi = " {bandwidthDownBytes}  {bandwidthUpBytes}";
          format-disconnected = "⚠ Disconnected";
          tooltip-format = "{ifname}: {ipaddr}/{cidr} ";
          tooltip-format-disconnected = "Disconnected";
          interval = 3;
        };

        tray = {
          icon-size = 12;
          spacing = 6;
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
}
