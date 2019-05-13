python << EOF
import threading
import time
import vim

thread_test_lock = threading.Lock()

def thread_test_echo_time():
    while True:
        thread_test_lock.acquire()
        t = threading.current_thread()
        print('thread id: ' + str(t.ident) + ': ' + str(time.time()))
        vim.command('doau User ThreadTest')
        thread_test_lock.release()
        time.sleep(1)

def thread_test_start():
    t = threading.Thread(target=thread_test_echo_time)
    t.daemon = True
    t.start()
EOF

function s:thread_start()
    python thread_test_start()
endfunction

function s:lock_acquire()
    python thread_test_lock.acquire(False)
    echo 'lock acquired'
endfunction

function s:lock_release()
python << EOF
try:
    thread_test_lock.release()
except:
    pass
EOF
    echo 'lock released'
endfunction

function s:show_thread_id()
python << EOF
t = threading.current_thread()
print('thread id: ' + str(t.ident))
EOF
endfunction

au CursorHold,CursorHoldI * call s:lock_release()
au ShellCmdPost,ShellFilterPost,CursorMoved,CursorMovedI,QuickFixCmdPre * call s:lock_acquire()
nnoremap : :call <SID>lock_acquire()<CR>:

command ThreadTest call s:thread_start()
