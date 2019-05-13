#!python
import subprocess
from subprocess import PIPE
import sys
import os

class VimClient:
    def __init__(self, servername, vim_bin='vim'):
        self.vim_bin = vim_bin
        self.servername = servername

    def remote_send(self, keys):
        return subprocess.call([self.vim_bin, '-i', 'NONE','-u', 'NORC', '-U', 'NONE', '-nNs',
                                              '--servername', self.servername,
                                              '--remote-send', keys],
                                              stdin=PIPE, stdout=sys.stderr, stderr=sys.stderr)

    def remote_expr(self, expr):
        cmdline = [self.vim_bin, '-i', 'NONE','-u', 'NORC', '-U', 'NONE', '-nNs',
                                 '--servername', self.servername,
                                 '--remote-expr', expr]
        sys.stdout.flush()

        return subprocess.check_output(cmdline, stdin=PIPE)

