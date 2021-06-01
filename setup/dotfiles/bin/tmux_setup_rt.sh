#!/bin/bash

tmux new-window
tmux split-window -h
tmux split-window -v -t 1
tmux split-window -v -t 2

# tmux send-keys -t 1 "ssh ttbg-shell101" Enter
# tmux send-keys -t 1 "zsh" Enter
tmux send-keys -t 1 "clear" Enter

# tmux send-keys -t 2 "ssh ttbg-shell101" Enter
# tmux send-keys -t 2 "zsh" Enter
tmux send-keys -t 2 "clear" Enter

# tmux send-keys -t 3 "ssh ttbg-shell101" Enter
# tmux send-keys -t 3 "zsh" Enter
tmux send-keys -t 3 "clear" Enter

# tmux send-keys -t 4 "ssh ttbg-shell101" Enter
# tmux send-keys -t 4 "zsh" Enter
tmux send-keys -t 4 "clear" Enter

