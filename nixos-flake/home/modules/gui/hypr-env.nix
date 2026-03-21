{ ... }:

{
  xdg.configFile."hypr/env.conf".text = ''
    xwayland {
      force_zero_scaling = true
    }

    ecosystem {
      no_update_news = true
    }
  '';
}
