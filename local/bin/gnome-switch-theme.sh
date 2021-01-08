#!/bin/bash
PID=$(pgrep -u $LOGNAME gnome-session | head -1)
export $(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$PID/environ)
if [ "$1" = "light" ]; then
    gsettings set org.gnome.desktop.interface gtk-theme "Adwaita"
elif [ "$1" = "dark" ]; then
    gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
fi
