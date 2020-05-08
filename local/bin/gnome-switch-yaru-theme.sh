#!/bin/bash
PID=$(pgrep -u $LOGNAME gnome-session | head -1)
export $(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$PID/environ)
gsettings set org.gnome.desktop.interface gtk-theme "Yaru-$1"
