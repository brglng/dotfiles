#!/usr/bin/env bash
set -e

source "$PWD/util.sh"

function do_pip_install {
    "$1" -m pip install --user -U pynvim autopep8 pylint jedi mypy pygments cppman neovim-remote
    echo
}

no_setup_proxy=0
for arg in "$@"; do
    if [[ $arg == "--no-setup-proxy" ]]; then
        no_setup_proxy=1
    fi
done

if [[ $CONDA_PREFIX != "" ]]; then
    echo "Your are in a conda environment. Please deactivate it before running this script."
    exit -1
fi

if [[ $no_setup_proxy == 0 && ($http_proxy == "" || $https_proxy == "") ]]; then
    while true; do
        read -p "Do you want to setup a proxy? (y/n): " yn
        echo
        case $yn in
            [Yy]*)
                while true; do
                    read -p "Please input your proxy address (e.g. http://127.0.0.1:8118): " proxy_address
                    echo
                    if [[ "$proxy_address" =~ ^http:// ]]; then
                        break
                    else
                        echo "Your proxy address must start with http://"
                        echo
                    fi
                done
                proxy_command="export http_proxy='$proxy_address' https_proxy='$proxy_address'"
                echo "$proxy_command"
                echo
                eval "$proxy_command"
                break;;
            [Nn]*)
                break;;
            *)
                echo "Please answer yes or no";;
        esac
    done
fi

echo "Please select what you want to do:"
PS3=">>> "
select opt in \
    "Set your user's default Python and install necessary packages" \
    "Only install necessary packages"; do
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
        $HOME/opt/miniconda3/bin \
        $HOME/opt/anaconda3/bin \
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
    read -p "Do you want also to link ~/.local/bin/python and ~/.local/bin/pip (not recommended) ? (y/n): " yn
    case $yn in
        [Yy]* )
            echo
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
