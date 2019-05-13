#!/usr/bin/env python
import os
import sys
import time
import vim
from subprocess import Popen, PIPE
from threading import Thread, Lock

class Taggist():
    def __init__(self):
        self._server_popen = None
        self._logs = []
        self._logger = None
        self._server_stdin_lock = Lock()
        self._server_stdout_lock = Lock()

    def server_is_alive(self):
        return _server_popen and self._server_popen.poll() == None

    def server_is_active(self):
        if self.server_is_alive(self):
            r = self.send_recv('ping')
            if r == 'ok':
                return True

    def get_server_logs(self):
        """Thread function for obtaining the log from the server's stderr"""

        while True:
            line = _server_popen.stderr.readline()
            self._logs.append(line)

        self._server_popen.stderr.close()

    def start_server(self):
        """Start taggistd"""

        cmdline = [vim.eval('g:taggist_python_bin'), os.path.join(os.path.dirname(__file__), '..', 'taggistd.py'),
                '--vim-bin', vim.eval('g:taggist_vim_bin'),
                '--vim-server-name', vim.eval('v:servername'),
                '--interval', vim.eval('g:taggist_interval'),
                '--config-file', vim.eval('g:taggist_config_file_name'),
                '--indexers', ','.join(vim.eval('g:taggist_indexers'))]

        if self.server_is_alive():
            self.stop_server()

        self._server_popen = Popen(cmdline, stdin=PIPE, stdout=PIPE, stderr=PIPE, universal_newlines=True)

        time.sleep(0.5)

        if self.server_is_alive():
            self._logs = []
            if not self._logger:
                self._logger = Thread(target=get_server_logs)
            self._logger.daemon = True
            self._logger.start()

    def stop_server(self):
        """Terminate taggistd"""

        if self._server_popen:
            self._server_popen.terminate()

    def send_recv(self, data):
        if self.server_is_alive():
            self._server_stdin_lock.acquire()
            self._server_popen.stdin.write(data)
            self._server_stdin_lock.release()

            self._server_stdout_lock.acquire()
            r = self._server_popen.stdout.readline()
            self._server_stdout_lock.release()

            return r

    def print_server_logs(self):
        for line in self._logs:
            print(line)
