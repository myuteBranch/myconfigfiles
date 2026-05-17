{
  pkgs,
  powermenuScript,
  ...
}:

{
  home.packages = [ pkgs.ashell ];

  xdg.configFile."ashell/config.toml".text = ''
    log_level = "warn"
    outputs = "All"
    position = "Top"
    layer = "Top"

    [modules]
    left = [ "Workspaces" ]
    center = [ "Tempo" ]
    right = [ [ "SystemInfo" ], [ "Tray", "Settings" ], "PowerMenu" ]

    [workspaces]
    visibility_mode = "MonitorSpecific"
    group_by_monitor = false
    enable_workspace_filling = true
    max_workspaces = 5

    [tempo]
    clock_format = "%A, %d %B %Y %H:%M"
    formats = [ "%A, %d %B %Y %H:%M", "%Y-%m-%d %H:%M:%S" ]
    weather_indicator = "None"

    [system_info]
    indicators = [ "Cpu", "Memory", "DownloadSpeed", "UploadSpeed", { Disk = "/", Name = "/" } ]
    interval = 2

    [system_info.cpu]
    warn_threshold = 70
    alert_threshold = 85

    [system_info.memory]
    warn_threshold = 75
    alert_threshold = 90

    [system_info.disk]
    warn_threshold = 80
    alert_threshold = 90

    [settings]
    audio_sinks_more_cmd = "pavucontrol -t 3"
    audio_sources_more_cmd = "pavucontrol -t 4"
    wifi_more_cmd = "nm-connection-editor"
    vpn_more_cmd = "nm-connection-editor"
    bluetooth_more_cmd = "blueman-manager"
    indicators = [ "Audio", "Network", "Bluetooth", "Battery" ]
    battery_format = "IconAndPercentage"
    audio_indicator_format = "IconAndPercentage"
    microphone_indicator_format = "Icon"
    network_indicator_format = "Icon"
    bluetooth_indicator_format = "Icon"
    brightness_indicator_format = "Icon"

    [[CustomModule]]
    name = "PowerMenu"
    type = "Button"
    icon = ""
    command = "${powermenuScript}"

    [appearance]
    style = "Islands"
    font_name = "CaskaydiaMono Nerd Font"
    scale_factor = 1.15
    opacity = 0.88
    text_color = "#d3c6aa"
    primary_color = "#bf9a06"
    success_color = "#26A65B"
    workspace_colors = [ "#bf9a06", "#d3c6aa" ]

    [appearance.danger_color]
    base = "#f53c3c"
    weak = "#ffbe61"

    [appearance.background_color]
    base = "#2d353b"
    weak = "#343f44"
    strong = "#232a2e"

    [appearance.secondary_color]
    base = "#1f2528"
    strong = "#151a1d"

  '';

  systemd.user.services.ashell = {
    Unit = {
      Description = "ashell status bar";
      After = [
        "graphical-session.target"
        "hyprland-session.target"
      ];
      PartOf = [
        "graphical-session.target"
        "hyprland-session.target"
      ];
    };

    Service = {
      ExecStart = "${pkgs.ashell}/bin/ashell --config-path %h/.config/ashell/config.toml";
      Restart = "on-failure";
      RestartSec = 1;
    };

    Install = {
      WantedBy = [
        "graphical-session.target"
        "hyprland-session.target"
      ];
    };
  };
}
