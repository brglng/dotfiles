#!python

import sys
import os
import subprocess
from subprocess import PIPE
import time

import taggist.indexer

class CscopeIndexer(taggist.indexer.Indexer):
    def index(self):
        try:
            while self._vimclient.remote_expr('mode()')[0] == 'c':
                time.sleep(0.2)
                pass

            self._vimclient.remote_expr('taggist#cscope#kill()')

            with open('cscope.files', 'w') as cscope_file:
                for includedir in self._config.includes():
                    cscope_file.write('-I ' + includedir + '\n')
                for source in self._config.sources():
                    cscope_file.write(source + '\n')
            subprocess.call([self._cmdargs.cscope_bin, '-b', '-c'], stdin=PIPE, stdout=sys.stderr, stderr=sys.stderr)
            self._vimclient.remote_expr("taggist#cscope#add('" + os.path.abspath(os.path.join(os.curdir, 'cscope.out')) + "', '" + os.path.abspath(os.curdir) + "')")
        except:
            pass

def indexer_init(arggroup):
    arggroup.add_argument('--cscope-bin', default='cscope')
    return CscopeIndexer
