#!/bin/bash

path=$1
project=$(basename $path)
echo $project
tmux new -d -s $project -c $path

window=1
tmux new-window -t $project:$window -n 'git' -c $path
tmux send-keys -t $project:$window "lazygit" C-m

window=2
tmux rename-window -t $project:$window 'nvim'
tmux send-keys -t $project:$window "nvim ." C-m

window=3
tmux new-window -t $project:$window -n 'term' -c $path
tmux send-keys -t $project:$window "ls -lra" C-m
