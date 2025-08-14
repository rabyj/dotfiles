#!/bin/bash
# A robust script to check RAM usage and send a desktop notification.
# To use, place this script in $HOME/bin/ and add a cron job to run it every minute.
# Open crontab: 'sudo crontab -u $USER -e'
# Cron job: '* * * * * $HOME/bin/check_ram.sh'

# --- Script Safety ---
# Exit immediately if a command exits with a non-zero status.
set -e
# Treat unset variables as an error when substituting.
set -u
# Pipes will return the exit code of the last command to exit with a non-zero status.
set -o pipefail

# --- Logic ---
# Calculate the percentage of used memory.
# The 'pipefail' option ensures that if `free` or `awk` fails, the script will exit.
percent=$(free -m | awk '/^Mem:/ {printf "%.0f", $3*100/$2}')

if [ "$percent" -ge 75 ]; then
  uid=$(id -u)

  # Export environment variables needed for a graphical session
  export DISPLAY=:0
  DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/${uid}/bus"
  export DBUS_SESSION_BUS_ADDRESS

  # Send a CRITICAL and PERSISTENT notification
  notify-send -u critical -h string:resident:true "High RAM Usage" "Memory is at ${percent}%"
fi
