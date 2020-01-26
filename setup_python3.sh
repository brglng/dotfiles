#!/bin/sh
while true; do
    read -p "Your current Python 3 is: `which python3`. Is that OK? (y/n) " yn
    case $yn in
        [Yy]* )
	    echo "OK. Let's go on...";
	    break;;
        [Nn]* )
	    echo "Stopped."
	    exit -1;;
        * )
            echo "Please answer yes or no.";;
    esac
done

python3 -m pip install --user -U pynvim neovim autopep8 pylint jedi

# vim: ts=8 sts=4 sw=4 et
