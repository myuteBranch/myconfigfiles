{ ... }:

{
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
