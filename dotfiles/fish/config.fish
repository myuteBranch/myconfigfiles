if status is-interactive
    # Commands to run in interactive sessions can go here
end

# starship
starship init fish | source
# abbr
source $HOME/.config/fish/conf.d/abbr.fish
