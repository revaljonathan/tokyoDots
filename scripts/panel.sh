#!/usr/bin/env bash
QDBUS="qdbus6"
SERVICE="luisbocanegra.panel.colorizer.c23.w49"
PRESET_DIR="$HOME/.config/panel-colorizer/presets"
PRESETS=(
    "Storm full"
    "Storm Default"
    "Storm Powerline"
    "Storm Cyan"
    "Storm Peach"
    "Storm Pink"
)
CHOICE=$(printf '%s\n' "${PRESETS[@]}" | rofi \
    -dmenu \
    -i \
    -p "Panel Preset" \
    -theme-str '
        window {
            width: 400px;
            border-radius: 12px;
        }
        mainbox {
            padding: 8px;
        }
        inputbar {
            padding: 10px 14px;
            border-radius: 8px;
            margin: 0 0 6px 0;
        }
        listview {
            lines: 8;
            fixed-height: false;
        }
        element {
            padding: 10px 14px;
            border-radius: 8px;
            margin: 2px 0;
        }
        element selected {
            border-radius: 8px;
        }
    '
)
case "$CHOICE" in
    *"Storm full"*)
        $QDBUS $SERVICE /preset preset "$PRESET_DIR/newfull"
        notify-send "Panel Preset" "Wow, the FULL storm. How bold. Your panel is now slightly different. Try not to faint. " --icon=preferences-desktop-theme
        ;;
    *"Storm line"*)
        $QDBUS $SERVICE /preset preset "$PRESET_DIR/newdefaultline"
        notify-send "Panel Preset" "A line. You chose a line. Shakespeare couldn't have written something this dramatic. " --icon=preferences-desktop-theme
        ;;
    *"Storm Default"*)
        $QDBUS $SERVICE /preset preset "$PRESET_DIR/newdefault"
        notify-send "Panel Preset" "Default. Out of ALL the options, you picked default. Truly a visionary. 🌧️"--icon=preferences-desktop-theme
        ;;
    *"Storm Powerline"*)
        $QDBUS $SERVICE /preset preset "$PRESET_DIR/newpowerline"
        notify-send "Panel Preset" "Powerline. Because regular lines clearly weren't powerful enough for someone of your status. " --icon=preferences-desktop-theme
        ;;
    *"Storm Cyan"*)
        $QDBUS $SERVICE /preset preset "$PRESET_DIR/newcyan"
        notify-send "Panel Preset" "Cyan. Not blue, not green — cyan. Your refined taste is genuinely overwhelming. " --icon=preferences-desktop-theme
        ;;
    *"Storm Peach"*)
        $QDBUS $SERVICE /preset preset "$PRESET_DIR/newpeach"
        notify-send "Panel Preset" "Peach. Your panel now looks like a fruit. Peak productivity achieved. " --icon=preferences-desktop-theme
        ;;
    *"Storm Pink"*)
        $QDBUS $SERVICE /preset preset "$PRESET_DIR/newpink"
        notify-send "Panel Preset" "Pink. Very edgy. Your panel is now the most intimidating thing on this desktop. " --icon=preferences-desktop-theme
        ;;
esac
