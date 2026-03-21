{
  pkgs,
  ...
}:

{
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
    config.common.default = "*";
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications =
      let
        browser = [ "vivaldi-stable.desktop" ];
        fileManager = [ "org.gnome.Nautilus.desktop" ];
        imageViewer = [ "org.gnome.Loupe.desktop" ];
        pdfViewer = [ "org.gnome.Evince.desktop" ];
        textEditor = [
          "dev.zed.Zed.desktop"
        ];
        videoPlayer = [ "mpv.desktop" ];
        audioPlayer = [ "mpv.desktop" ];
        archiveManager = [ "org.gnome.FileRoller.desktop" ];
      in
      {
        # Web / browser
        "text/html" = browser;
        "application/xhtml+xml" = browser;
        "application/xml" = browser;
        "text/xml" = browser;
        "application/rss+xml" = browser;
        "application/atom+xml" = browser;
        "x-scheme-handler/http" = browser;
        "x-scheme-handler/https" = browser;
        "x-scheme-handler/about" = browser;
        "x-scheme-handler/unknown" = browser;

        # Documents / text
        "text/plain" = textEditor;
        "text/markdown" = textEditor;
        "text/csv" = textEditor;
        "application/json" = textEditor;
        "application/pdf" = pdfViewer;

        # Images
        "image/png" = imageViewer;
        "image/jpeg" = imageViewer;
        "image/gif" = imageViewer;
        "image/webp" = imageViewer;
        "image/svg+xml" = browser;

        # Audio / video
        "audio/mpeg" = audioPlayer;
        "audio/flac" = audioPlayer;
        "audio/ogg" = audioPlayer;
        "audio/wav" = audioPlayer;
        "video/mp4" = videoPlayer;
        "video/x-matroska" = videoPlayer;
        "video/webm" = videoPlayer;
        "video/quicktime" = videoPlayer;
        "video/x-msvideo" = videoPlayer;

        # Archives
        "application/zip" = archiveManager;
        "application/x-tar" = archiveManager;
        "application/x-7z-compressed" = archiveManager;
        "application/x-rar" = archiveManager;
        "application/gzip" = archiveManager;
        "application/x-bzip2" = archiveManager;

        # Directories
        "inode/directory" = fileManager;
      };
  };

  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };

  gtk = {
    enable = true;

    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Grey-Darkest";
    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

    font = {
      name = "CaskaydiaMono Nerd Font";
      size = 11;
    };
  };
}
