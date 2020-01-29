#!/usr/bin/env bash
set -e

source "$PWD/util.sh"

function do_pip_install {
    "$1" -m pip install --user -U pynvim autopep8 pylint jedi
    echo
}

while true; do
    echo "If your Internet is slow, it is recommended that you setup a proxy before continuing."
    read -p "Do you want to continue? (y/n): " yn
    case $yn in
        [Yy]* )
	    break;;
        [Nn]* )
	    echo "Stopped."
	    exit -1;;
	* )
	    ;;
    esac
done
echo

echo "Please select what you want to do:"
PS3=">>> "
select opt in \
    "Change your user's default Python and install necessary packages for Vim and Neovim" \
    "Only install necessary packages for Vim and Neovim"; do
    case $REPLY in
        1)
            break;;
        2)
            if type python3 &>/dev/null; then
                type python3
                do_pip_install python3
            else
                "You are not in an environment where python3 binary is in your PATH."
                exit -1
            fi
            exit;;
        *)
            echo "Please choose 1 or 2"
    esac
done
echo

echo "Searching for Python 3 in your system..."
for py in python3 python; do
    for d in \
        $HOME/miniconda3/bin \
        $HOME/anaconda3/bin \
        /miniconda3/bin \
        /anaconda3/bin \
        $HOME/.local/bin \
        /usr/local/bin \
        /usr/bin \
        /bin; do
        if [[ -x "$d/$py" ]]; then
            found=0
            if [[ $("$d/$py" -c 'import sys; print(sys.version_info[0])') == 3 ]]; then
                for p in ${all_pythons[@]}; do
                    if [[ $(readlinkf "$p") = $(readlinkf "$d/$py") ]]; then
                        found=1
                    fi
                done
                if [[ $found == 0 ]]; then
                    all_pythons[${#all_pythons[@]}]=$d/$py
                fi
            fi
        fi
    done
done
echo

if [[ ${#all_pythons[@]} == 0 ]]; then
    echo "Python 3 not found!"
    exit -1
fi

echo "Which Python do you want to use by default?"
PS3=">>> "
select selected_py in "${all_pythons[@]}"; do
    if [[ $selected_py = "" ]]; then
        echo "Please enter number between 1 and ${#all_pythons[@]}"
    else
        break
    fi
done
echo

link $selected_py "$HOME/.local/bin/python3"
if [[ -x "$(dirname $selected_py)/pip3" ]]; then
    link "$(dirname $selected_py)/pip3" "$HOME/.local/bin/pip3"
elif [[ -x "$(dirname $selected_py)/pip" ]]; then
    link "$(dirname $selected_py)/pip" "$HOME/.local/bin/pip3"
fi
echo
echo "~/.local/bin/python3 and ~/.local/bin/pip3 has been linked to your selection of Python."
echo

while true; do
    read -p "Do you want also to link ~/.local/bin/python and ~/.local/bin/pip ? (y/n): " yn
    case $yn in
        [Yy]* )
            link "$selected_py" "$HOME/.local/bin/python"
            if [[ -x "$(dirname $selected_py)/pip3" ]]; then
                link "$(dirname $selected_py)/pip3" "$HOME/.local/bin/pip"
            elif [[ -x "$(dirname $selected_py)/pip" ]]; then
                link "$(dirname $selected_py)/pip" "$HOME/.local/bin/pip"
            fi
	    break;;
        [Nn]* )
	    break;;
        * )
            echo "Please answer yes or no.";;
    esac
done
echo

do_pip_install "$selected_py"

for py in ${all_pythons[@]}; do
    if [[ $py == *"miniconda"* || $py == *"anaconda"* ]]; then
        while true; do
            read -p "Do you want to disable Conda's auto-activation of the base environment (recommended) ? (y/n): " yn
            case $yn in
                [Yy]* )
                    $(dirname "$py")/conda config --set auto_activate_base false
	            break;;
                [Nn]* )
	            break;;
                * )
                    echo "Please answer yes or no.";;
            esac
        done
        break
    fi
done
echo

echo "Done."

# vim: ts=8 sts=4 sw=4 et
