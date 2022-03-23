#!/bin/bash
PID=$(pgrep -u $LOGNAME gnome-session | head -1)
export $(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$PID/environ)
if [ "$1" = "light" ]; then
    gsettings set org.gnome.desktop.interface gtk-theme "Yaru-light"
    gsettings set org.gnome.Terminal.ProfilesList default '94c58ad0-020c-4636-83ff-6bf67bdd247d'
elif [ "$1" = "dark" ]; then
    gsettings set org.gnome.desktop.interface gtk-theme "Yaru-dark"
    gsettings set org.gnome.Terminal.ProfilesList default '69b54d3f-ee0a-41f9-8e3a-28c12849bde5'
fi
