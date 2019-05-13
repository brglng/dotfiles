#!python
import threading

class Indexer(threading.Thread):
    """Indexer interface for exuberant-ctags, cscope, GNU Global, etc."""
    _event = threading.Event()

    def __init__(self, interval, config, vim_client, cmdargs):
        threading.Thread.__init__(self)
        self._event = threading.Event()
        self._interval = interval
        self._config = config
        self._vimclient = vim_client
        self._cmdargs = cmdargs

    def index(self):
        pass

    def run(self):
        while not self._event.is_set():
            self.index()
            self._event.wait(self._interval)

    def stop(self):
        self._event.set()
