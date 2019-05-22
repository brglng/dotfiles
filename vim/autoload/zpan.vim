function zpan#is_sudo() abort
  return $SUDO_USER !=# '' && $USER !=# $SUDO_USER && $HOME !=# expand('~'.$USER)
endfunction
