{ ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      colors = {
        primary = {
          background = "0x000000";
          foreground = "0xffffff";
        };

        normal = {
          black = "0x000000";
          red = "0xff5f87";
          green = "0x87ff87";
          yellow = "0xffff87";
          blue = "0x5fafff";
          magenta = "0xd787ff";
          cyan = "0x87ffff";
          white = "0xffffff";
        };

        bright = {
          black = "0x444444";
          red = "0xff87af";
          green = "0xb2ffb2";
          yellow = "0xffffb2";
          blue = "0x87cfff";
          magenta = "0xe3afff";
          cyan = "0xb2ffff";
          white = "0xffffff";
        };

        cursor.cursor = "0xffff00";
      };

      env.TERM = "xterm-256color";

      font = {
        size = 9.0;
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Italic";
        };
        bold_italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold Italic";
        };
        offset = {
          x = 1;
          y = 1;
        };
      };

      keyboard.bindings = [
        {
          action = "Paste";
          key = "V";
          mods = "Control|Shift";
        }
        {
          action = "Copy";
          key = "C";
          mods = "Control|Shift";
        }
        {
          action = "PasteSelection";
          key = "Insert";
          mods = "Shift";
        }
        {
          action = "ResetFontSize";
          key = "Key0";
          mods = "Control";
        }
        {
          action = "IncreaseFontSize";
          key = "Equals";
          mods = "Control";
        }
        {
          action = "IncreaseFontSize";
          key = "ZoomIn";
          mods = "Control";
        }
        {
          action = "DecreaseFontSize";
          key = "ZoomOut";
          mods = "Control";
        }
        {
          action = "DecreaseFontSize";
          key = "Minus";
          mods = "Control";
        }
        {
          action = "Paste";
          key = "Paste";
        }
        {
          action = "Copy";
          key = "Copy";
        }
        {
          action = "ClearLogNotice";
          key = "L";
          mods = "Control";
        }
        {
          chars = "\\f";
          key = "L";
          mods = "Control";
        }
        {
          action = "ScrollPageUp";
          key = "PageUp";
          mode = "~Alt";
          mods = "Shift";
        }
        {
          action = "ScrollPageDown";
          key = "PageDown";
          mode = "~Alt";
          mods = "Shift";
        }
        {
          action = "ScrollToTop";
          key = "Home";
          mode = "~Alt";
          mods = "Shift";
        }
        {
          action = "ScrollToBottom";
          key = "End";
          mode = "~Alt";
          mods = "Shift";
        }
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
}
