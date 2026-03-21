{ config, lib, ... }:

let
  userEnvironment = {
    EDITOR = "nvim";
    VISUAL = "zeditor";
    TERMINAL = "alacritty";
    NIXOS_OZONE_WL = "1";

    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";

    GDK_BACKEND = "wayland,x11,*";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_STYLE_OVERRIDE = "kvantum";
    SDL_VIDEODRIVER = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    OZONE_PLATFORM = "wayland";

    XCURSOR_SIZE = "24";
    HYPRCURSOR_SIZE = "24";

    GTK_THEME = "Flat-Remix-GTK-Grey-Darkest";
    XCOMPOSEFILE = "${config.home.homeDirectory}/.XCompose";
  };
in
{
  systemd.user.sessionVariables = userEnvironment;

  home.sessionVariables = lib.mkMerge [
    userEnvironment
    {
      # Keep Home Manager shells aligned with the user systemd environment.
      XCOMPOSEFILE = lib.mkDefault "${config.home.homeDirectory}/.XCompose";
    }
  ];
}
