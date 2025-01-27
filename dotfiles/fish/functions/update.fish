function update_all
    # title " - Fetching New Mirror List"
    # fetch new mirrors

    sudo pacman -Syy

    #title "Updating Official Packages"
    sudo pacman -Su --disable-download-timeout

    if test (command -v paru)
        #title "Updating AUR Packages (paru)"
        paru -Su --disable-download-timeout
    else if test (command -v yay)
        #title "Updating AUR Packages (yay)"
        yay -Su --disable-download-timeout
    end

    if test (command -v pkgfile)
        #title "Updating Repo Files Lists"
        sudo pkgfile -u
    end

    #title "Updating Fish Completions"
    fish_update_completions

    #title "Rebuilding Font Cache Files"
    fc-cache -frv
end
