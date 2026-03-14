{ pkgs, ... }:

let
  rofiCalcMode = pkgs.writeShellScript "rofi-calc-mode" ''
    if [ "''${ROFI_RETV:-0}" = "0" ]; then
      echo "Calculator"
      exit 0
    fi

    expression="$1"

    [ -z "$expression" ] && exit 0

    result="$(${pkgs.libqalculate}/bin/qalc -t "$expression" 2>/dev/null | tail -n1)"

    if [ -z "$result" ]; then
      echo "Invalid expression"
      exit 0
    fi

    printf "%s" "$result" | ${pkgs.wl-clipboard}/bin/wl-copy
    ${pkgs.libnotify}/bin/notify-send "Calculator" "$result copied to clipboard"
    echo "$result"
  '';

  rofiScreenshotMode = pkgs.writeShellScript "rofi-screenshot-mode" ''
    dir="$HOME/Pictures/Screenshots"
    mkdir -p "$dir"

    regioncb="󰹑 Region to Clipboard"
    region="󰹑 Region to File"
    delaycb="󰹑 Delayed Region to Clipboard"
    delayfile="󰹑 Delayed Region to File"

    if [ "''${ROFI_RETV:-0}" = "0" ]; then
      printf "%s\n%s\n%s\n%s\n" "$regioncb" "$region" "$delaycb" "$delayfile"
      exit 0
    fi

    (
      case "$1" in
        "$regioncb")
          ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.wl-clipboard}/bin/wl-copy
          ${pkgs.libnotify}/bin/notify-send "Screenshot copied"
          ;;
        "$region")
          file="$dir/$(date +'%Y-%m-%d_%H-%M-%S').png"
          ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" "$file"
          ${pkgs.wl-clipboard}/bin/wl-copy < "$file"
          ${pkgs.libnotify}/bin/notify-send "Screenshot saved" "$file"
          ;;
        "$delaycb")
          ${pkgs.libnotify}/bin/notify-send "Screenshot" "Taking delayed region screenshot in 5 seconds"
          ${pkgs.coreutils}/bin/sleep 5
          ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.wl-clipboard}/bin/wl-copy
          ${pkgs.libnotify}/bin/notify-send "Screenshot copied"
          ;;
        "$delayfile")
          ${pkgs.libnotify}/bin/notify-send "Screenshot" "Taking delayed region screenshot in 5 seconds"
          ${pkgs.coreutils}/bin/sleep 5
          file="$dir/$(date +'%Y-%m-%d_%H-%M-%S').png"
          ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" "$file"
          ${pkgs.wl-clipboard}/bin/wl-copy < "$file"
          ${pkgs.libnotify}/bin/notify-send "Screenshot saved" "$file"
          ;;
      esac
    ) >/dev/null 2>&1 &
    exit 0
  '';
in
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    terminal = "alacritty";
    theme = ./rofitheme.rafi;

    extraConfig = {
      modi = "drun,calc:${rofiCalcMode},screenshot:${rofiScreenshotMode},run,window";
      icon-theme = "Papirus";
      show-icons = true;
      drun-display-format = "{icon} {name}";
      location = 0;
      disable-history = false;
      hide-scrollbar = true;
      display-drun = " Apps";
      display-run = " Run";
      display-window = " Win";
      display-calc = " Calc";
      display-screenshot = "󰹑 Shot";
      sidebar-mode = true;
      kb-row-down = "Down,Control+n";
      kb-row-up = "Up,Control+p";
      kb-mode-complete = "Control+Shift+Right";
      kb-mode-next = "Shift+Right,Control+l";
      font = "JetBrainsMono Nerd Font 10";
    };
  };
}
