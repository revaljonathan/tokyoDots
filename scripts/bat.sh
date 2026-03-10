#!/bin/bash
# battery_status.sh - Linux only, for status bars (waybar, polybar, i3blocks, etc.)
# Try upower first, fallback to /sys/class/power_supply
if command -v upower &>/dev/null; then
    info=$(upower -i "$(upower -e | grep -i battery | head -1)" 2>/dev/null)
    PERCENT=$(echo "$info" | grep -E "percentage" | grep -oP '\d+')
    STATUS=$(echo "$info" | grep -E "state" | awk '{print $2}')
fi
if [ -z "$PERCENT" ]; then
    bat=$(ls /sys/class/power_supply/ 2>/dev/null | grep -iE "^BAT" | head -1)
    if [ -n "$bat" ]; then
        PERCENT=$(cat "/sys/class/power_supply/$bat/capacity")
        STATUS=$(cat "/sys/class/power_supply/$bat/status" | tr '[:upper:]' '[:lower:]')
    fi
fi
[ -z "$PERCENT" ] && { echo "󰂑 N/A"; exit 0; }

# Detect AC adapter (plugged in)
AC_ONLINE=false
for ac in /sys/class/power_supply/AC* /sys/class/power_supply/ACAD* /sys/class/power_supply/ADP*; do
    if [ -f "$ac/online" ] && [ "$(cat "$ac/online")" = "1" ]; then
        AC_ONLINE=true
        break
    fi
done

# Charging icons
C=(󰢟 󰢜 󰂆 󰂇 󰂈 󰢝 󰂉 󰢞 󰂊 󰂋 󰂅)
# Discharging icons
D=(󰂎 󰁺 󰁻 󰁼 󰁽 󰁾 󰁿 󰂀 󰂁 󰂂 󰁹)

echo "$STATUS" | grep -qi "full"  && { echo "󰁹 Full"; exit 0; }
echo "$STATUS" | grep -qi "charg" && IS_CHARGING=true || IS_CHARGING=false

# Conservation mode: plugged in but not charging (and not full)
if [ "$AC_ONLINE" = true ] && [ "$IS_CHARGING" = false ]; then
    echo "󰈐 ${PERCENT}%"
    exit 0
fi

# Pick icon from array (index 0–10 mapped from 0–100%)
idx=$(( PERCENT / 10 ))
[ "$idx" -gt 10 ] && idx=10

# Low battery alert (discharging, ≤10%)
if [ "$IS_CHARGING" = false ] && [ "$PERCENT" -le 10 ]; then
    echo "󰂃 ${PERCENT}%"
    exit 0
fi

[ "$IS_CHARGING" = true ] && ICON="${C[$idx]}" || ICON="${D[$idx]}"
echo "$ICON ${PERCENT}%"
