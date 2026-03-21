{ pkgs, username, ... }:

{
  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";

  nixpkgs.config.allowUnfree = true;

  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [
      "wheel"
      "docker"
      "networkmanager"
    ];
    shell = pkgs.fish;
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "dvorak";
    options = "grp:alt_shift_toggle";
  };

}
