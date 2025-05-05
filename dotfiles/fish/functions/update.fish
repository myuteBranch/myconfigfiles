function update_all
    #title "Updating Official Packages"
    sudo pacman -Syu

    if test (command -v paru)
        #title "Updating AUR Packages (paru)"
        paru -Syu
    else if test (command -v yay)
        #title "Updating AUR Packages (yay)"
        yay -Syu
    end

    #title "Updating Fish Completions"
    fish_update_completions

    #title "Rebuilding Font Cache Files"
    fc-cache -frv
end
