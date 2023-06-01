#!/bin/bash

UB_PID_FILE="/tmp/.$(uuidgen)"
ueberzugpp layer --no-stdin --silent --use-escape-codes --pid-file $UB_PID_FILE
UB_PID=$(cat $UB_PID_FILE)

export SOCKET=/tmp/ueberzugpp-$UB_PID.socket
export X=$(($(tput cols) / 2 + 1))

# run fzf with preview
fzf --preview='
if string match -q -r ".*\.(png|jpg|jpeg)\$" {}
    ueberzugpp cmd -s $SOCKET -i fzfpreview -a add -x $X -y 1 --max-width $FZF_PREVIEW_COLUMNS --max-height $FZF_PREVIEW_LINES -f {}
else
    ueberzugpp cmd -s $SOCKET -a remove
    bat --color always {}
end
' "$@"

ueberzugpp cmd -s $SOCKET -a exit
