#!/bin/bash

path=$1
project=$(basename $path)
echo $project
tmux new -d -s $project -c $path

window=1
tmux rename-window -t $project:$window 'nvim'
tmux send-keys -t $project:$window "jj" C-m

window=2
tmux new-window -t $project:$window -n 'term' -c $path
tmux send-keys -t $project:$window "ls -lra" C-m
