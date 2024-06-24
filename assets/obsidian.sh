#!/bin/bash
exec &>/dev/null  # fix no stdout/stderr error

export DISPLAY=:0

if id=$(xdotool search --class obsidian)
then
	id=$(echo "$id" | tail -1)
	state=$(xwininfo -id $id | awk -F': ' '$1 ~ /Map State/ { print $2; }')
	if [[ "$state" = IsUnMapped ]]
	then
		xdotool windowmap $id
		xdotool windowactivate $id
	else
		xdotool windowunmap $id
	fi
else
	prime-run obsidian $@ & disown
	xdotool search --sync --class obsidian windowactivate
fi
