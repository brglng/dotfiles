let s:winnr_stack = []
let s:num_wins = winnr('$')
let g:_cursorman_popping = 0

function g:cursorman_peak_top()
    if len(s:winnr_stack) == 0
        return -1
    else
        return s:winnr_stack[-1]
    endif
endfunction

function g:cursorman_pop()
    if len(s:winnr_stack) > 1
        call remove(s:winnr_stack, -1)
        let g:_cursorman_popping = 1
        if len(s:winnr_stack) > 1
            execute s:winnr_stack[-2] . ' wincmd w'
        else
            execute s:winnr_stack[-1] . ' wincmd w'
        endif
        if len(s:winnr_stack) > 0
            execute s:winnr_stack[-1] . ' wincmd w'
        endif
        let g:_cursorman_popping = 0
        echo s:winnr_stack
    endif
endfunction

function s:on_win_enter()
    if !g:_cursorman_popping
        let curwinnr = winnr()
        let curnumwins = winnr('$')
        if curnumwins > s:num_wins
            for l:i in range(len(s:winnr_stack))
                if s:winnr_stack[l:i] >= curwinnr + 1
                    let s:winnr_stack[l:i] += 1
                endif
            endfor
        elseif curnumwins < s:num_wins
            let l:i = index(s:winnr_stack, curwinnr)
            while l:i != -1
                call remove(s:winnr_stack, l:i)
                let l:i = index(s:winnr_stack, curwinnr)
            endwhile
            for l:i in range(len(s:winnr_stack))
                if s:winnr_stack[l:i] > curwinnr
                    let s:winnr_stack[l:i] -= 1
                endif
            endfor
        endif
        let s:num_wins = curnumwins
        if g:cursorman_peak_top() != curwinnr
            call add(s:winnr_stack, curwinnr)
        endif
        echo s:winnr_stack
    endif
endfunction

augroup CursorMan
    autocmd WinEnter * call s:on_win_enter()
augroup END

nnoremap <A-w>p :call g:cursorman_pop()<CR>
