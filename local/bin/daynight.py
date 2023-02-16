#!/usr/bin/env python3
from datetime import datetime, timedelta, timezone
import logging
import time
import subprocess
import requests


logger = logging.getLogger(__name__)


def get_sunrise_sunset_times(latitude: int, longitude: int):
    resp = requests.get(f'https://api.sunrise-sunset.org/json?lat={latitude}&lng={longitude}&formatted=0')
    resp.raise_for_status()
    response = resp.json()
    if response['status'] != 'OK':
        raise Exception(f'{response["status"]}')
    sunrise = response['results']['sunrise']
    sunset = response['results']['sunset']
    sunrise_dt = datetime.fromisoformat(sunrise)
    sunset_dt = datetime.fromisoformat(sunset)
    sunrise_dt = sunrise_dt.astimezone(timezone(timedelta(hours=8)))
    sunset_dt = sunset_dt.astimezone(timezone(timedelta(hours=8)))
    logger.info('sunrise_dt: %s', sunrise_dt)
    logger.info('sunset_dt: %s', sunset_dt)
    return sunrise_dt, sunset_dt


def get_gnome_terminal_profile_dict():
    profile_list = subprocess.check_output(['gsettings', 'get', 'org.gnome.Terminal.ProfilesList', 'list']).decode().rstrip('\r\n')
    profile_list = profile_list.lstrip('[').rstrip(']').split(',')
    profile_list = [p.lstrip(' ').lstrip("'").rstrip("'") for p in profile_list]
    profile_dict = {}
    for profile_repr in profile_list:
        profile = profile_repr.lstrip(' ').lstrip("'").rstrip("'")
        profile_name = subprocess.check_output(
            ['gsettings',
             'get',
             f'org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:{profile}/',
             'visible-name']).decode().rstrip('\r\n')
        profile_dict[profile_name.lstrip("'").rstrip("'")] = profile
    return profile_dict


def switch_gtk_theme(theme: str):
    subprocess.check_call([
        'gsettings', 'set',
        'org.gnome.desktop.interface',
        'gtk-theme',
        theme
    ])


def switch_gnome_terminal_profile(profile_name: str):
    profile_dict = get_gnome_terminal_profile_dict()
    logger.info('profile_dict: %s', profile_dict)
    profile = profile_dict[profile_name]

    # switch for the first terminal window
    subprocess.check_call(['busctl', '--auto-start=false', '-j', '--user', 'call', 'org.gnome.Terminal', '/org/gnome/Terminal/window/1', 'org.gtk.Actions', 'Activate', 'sava{sv}', 'profile', '1', 's', profile, '0'])

    # set default profile
    subprocess.check_call(['gsettings', 'set', 'org.gnome.Terminal.ProfilesList', 'default', profile])


def main():
    logging.basicConfig(level=logging.INFO)
    while True:
        try:
            sunrise, sunset = get_sunrise_sunset_times(31, 121)
            now = datetime.now(tz=timezone(timedelta(hours=8)))
            if sunrise <= now <= sunset:
                switch_gtk_theme('Yaru-light')
                switch_gnome_terminal_profile('Catppuccin Latte')
            else:
                switch_gtk_theme('Yaru-dark')
                switch_gnome_terminal_profile('Catppuccin Mocha')
        except Exception as e:
            logger.exception(e)
        finally:
            time.sleep(60)


if __name__ == '__main__':
    main()
