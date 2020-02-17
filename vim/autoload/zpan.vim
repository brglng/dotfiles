function! zpan#is_sudo() abort
    return $SUDO_USER !=# '' && $USER !=# $SUDO_USER && $HOME !=# expand('~'.$USER)
endfunction

function! zpan#rstrip(str, chars) abort
    if strlen(a:str) > 0 && strlen(a:chars) > 0
        let i = strlen(a:str) - 1
        while i >= 0
            if stridx(a:chars, a:str[i]) >= 0
                let i -= 1
            else
                break
            endif
        endwhile
        if i == -1
            let i = 0
        endif
        return a:str[0:i]
    else
        return a:str
    endif
endfunction

function! zpan#pumselected() abort
    return pumvisible() && !empty(v:completed_item)
endfunction

function! zpan#is_tool_window(...) abort
    if len(a:000) == 0
        return index(['coc-explorer', 'defx', 'denite', 'gitv', 'help', 'man', 'qf', 'undotree'], &filetype) >= 0 || expand('%:t') =~ '__Tagbar__\|__vista__'
    elseif len(a:000) == 1
        let winnr = a:1
        let bufnr = winbufnr(winnr)
        let fname = bufname(bufnr)
        let filetype = getwinvar(winnr, '&filetype')
        return index(['defx', 'denite', 'gitv', 'help', 'man', 'qf', 'undotree'], filetype) >= 0 || fname =~ '__Tagbar__\|__vista__'
    else
        echoerr "must be 0 or 1 arguments"
    endif
endfunction

function! zpan#install_missing_plugins(sync) abort
    if zpan#is_sudo()
        return
    endif

    if &diff
        return
    endif

    let all_installed_plugins = {}
    if has('win32')
        let os_sep = '\\'
    else
        let os_sep = '/'
    endif
    for d in glob(g:plug_home . '/*', v:false, v:true)
        if isdirectory(d)
            if has('win32')
                let all_installed_plugins[split(d, os_sep)[-1]] = v:null
            else
                let all_installed_plugins[split(d, os_sep)[-1]] = v:null
            endif
        endif
    endfor

    let have_uninstalled_plugins = v:false
    for [name, info] in items(g:plugs)
        if !has_key(all_installed_plugins, name)
            let have_uninstalled_plugins = v:true
            break
        endif
    endfor

    if have_uninstalled_plugins
        if a:sync
            PlugInstall --sync
        else
            PlugInstall
        endif
    endif
endfunction

" vim: ts=8 sts=4 sw=4 et
