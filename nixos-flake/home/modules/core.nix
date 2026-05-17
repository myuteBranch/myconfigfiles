{ pkgs, ... }:

let
  vivaldiShare = pkgs.writeShellScriptBin "vivaldi-share" ''
    exec ${pkgs.vivaldi}/bin/vivaldi \
      --enable-features=WebRTCPipeWireCapturer \
      --ozone-platform-hint=auto \
      "$@"
  '';
in
{

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    evince
    loupe
    libqalculate
    just
    freerdp
    vivaldi
    vivaldiShare
    go
    rustup
    tree-sitter
    nodejs
    nil
    nixd
    alejandra
    gopls
    lua-language-server
    stylua
    mpv
  ];

  programs.zed-editor = {
    enable = true;
  };

  # Override desktop launcher to force PipeWire screen-share flags.
  xdg.desktopEntries."vivaldi-stable" = {
    name = "Vivaldi";
    genericName = "Web Browser";
    exec = "vivaldi-share %U";
    terminal = false;
    icon = "vivaldi";
    type = "Application";
    categories = [
      "Network"
      "WebBrowser"
    ];
    mimeType = [
      "application/pdf"
      "application/rdf+xml"
      "application/rss+xml"
      "application/xhtml+xml"
      "application/xhtml_xml"
      "application/xml"
      "image/gif"
      "image/jpeg"
      "image/png"
      "image/webp"
      "text/html"
      "text/xml"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
    ];
    startupNotify = true;
  };
}
