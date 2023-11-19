#!/bin/bash

project=$1
tmux new -d -s $project
window=1
tmux rename-window -t $project:$window 'nvim'
tmux send-keys -t $project:$window "cd $project" C-m

window=2
tmux new-window -t $project:$window -n 'term'
tmux send-keys -t $project:$window "cd $project" C-m

window=3
tmux new-window -t $project:$window -n 'git'
tmux send-keys -t $project:$window "cd $project && lazygit" C-m
