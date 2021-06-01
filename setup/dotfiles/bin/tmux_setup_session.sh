if [ $# != 1 ]
then
    echo "usage: tmux_setup_session.sh <session-name>"
    exit -1
fi
if ! tmux has-session -t $1; then
tmux new -s $1 -d
    tmux new-window -t $1:2
    tmux split-window -t $1:2 -h
    tmux send-keys -t $1:1 ls Enter
    tmux send-key -t $1:2.1 \
        top Enter
    tmux send-keys -t $1:2.2 \
        "ps -ax" Enter
fi
tmux attach -t $1
