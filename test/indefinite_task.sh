#!/bin/bash

[ -x $(command -v terminal-notifier) ] \
  || [ -x $(command -v notify-send) ] \
  || { echo "No notifier found"; exit 1; }

function cleanup {
  title="Script Terminated"
  message="The script has been stopped by a termination signal."

  if [ -x $(command -v terminal-notifier) ]; then
    terminal-notifier -title "$title" -message "$message"
  elif [ -x $(command -v notify-send) ]; then
    notify-send "$title" "$message"
  fi

  exit 0
}

trap cleanup SIGINT SIGTERM SIGHUP

echo "Script is running. Press Ctrl+C to stop."

while true; do
  sleep 1
done
