#!/bin/bash

UB_PID_FILE="/tmp/.$(uuidgen)"
ueberzugpp layer --no-stdin --silent --use-escape-codes --pid-file "$UB_PID_FILE"
UB_PID=$(cat "$UB_PID_FILE")

export SOCKET="/tmp/ueberzugpp-$UB_PID.socket"
export X=$(($(tput cols) / 2 + 1))

# run fzf with preview
fzf --preview 'set file {}; if string match -r ".*\.(png|jpg|jpeg)$" $file; ueberzugpp cmd -s $SOCKET -i fzfpreview -a add -x $X -y 1 --max-width $FZF_PREVIEW_COLUMNS --max-height $FZF_PREVIEW_LINES -f $file; else bat --color always $file; end' --reverse "$@"

ueberzugpp cmd -s "$SOCKET" -a exit
