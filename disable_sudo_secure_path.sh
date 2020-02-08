#!/bin/bash

set -e

if [[ $(uname -s) != "Linux" ]]; then
    echo "Your system is not Linux. Ignored sudo fix."
    exit
fi

disable_sudo_secure_path() {
    local bold=$(tput bold)
    local sgr0=$(tput sgr0)
    while true; do
        echo "Do you want to disable ${bold}secure_path${sgr0} for ${bold}sudo${sgr0}?"
        echo "If you choose ${bold}no${sgr0}, you will not be able to use programs under ${bold}~/.local/bin${sgr0} (including programs installed by ${bold}install.sh${sgr0}) under sudo."
        echo 'This can a be a little bit insecure, so choose at your own risk.'
        read -p '(y/n): ' yn
        case $yn in
            [Yy]*)
                if [[ -e /etc/sudoers ]]; then
                    mkdir -p "/home/$SUDO_USER/.local/tmp"
                    perl -pe 's/^(Defaults[\t ]+secure_path=.*)/#\1/g' /etc/sudoers > "/home/$SUDO_USER/.local/tmp/sudoers"
                    if [[ $(perl -ne 'print $1 if /^(Defaults[\t ]+!secure_path)/' "/home/$SUDO_USER/.local/tmp/sudoers") == '' ]]; then
                        echo 'Defaults	!secure_path' >> "/home/$SUDO_USER/.local/tmp/sudoers"
                    fi
                    mv "/home/$SUDO_USER/.local/tmp/sudoers" /etc/sudoers
                    chown root:root /etc/sudoers
                    chmod 400 /etc/sudoers
                else
                    echo 'Defaults	!secure_path' > /etc/sudoers
                    chown root:root /etc/sudoers
                    chmod 400 /etc/sudoers
                fi
                break;;
            [Nn]*)
                break;;
        esac
    done
}

sudo bash -e -c "$(declare -f disable_sudo_secure_path); disable_sudo_secure_path"
