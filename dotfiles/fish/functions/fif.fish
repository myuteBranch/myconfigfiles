function fif
  if count $argv > /dev/null
    set -f sstr "$argv"
    rg --files-with-matches --no-messages "$sstr" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:       bg:yellow' --ignore-case --pretty --context 10 '$sstr' || rg --ignore-case --pretty --context 10 '$sstr' {}"
  else
    echo "Please provide a search string"
  end
end
