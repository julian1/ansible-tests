#!/bin/bash
# deployed by ansible!

## OK - this can be converted to a systemd service by simply having systemd start a loop script
## eg.  loop.sh 30 low_battery_alert.sh 

threshold=50
capacity=$(cat /sys/class/power_supply/BAT0/capacity)
status=$(cat /sys/class/power_supply/BAT0/status)

beep() {
  # $1 duration in seconds, $2 freq
  timeout -k ${1}s ${1}s speaker-test --frequency ${2} --test sine 2> /dev/null
}

# test
# beep 0.1 500

# ok. output redirection will be handled by cron. service / systemd
echo "$(date) whoami=$(whoami), status=$status, threshold=$threshold, capacity=$capacity"

# beep if below threshold and not charging
if [ $capacity -le $threshold ] && [ $status != "Charging" ] ; then
  beep 0.1 500
fi
