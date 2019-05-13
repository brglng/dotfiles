#!python

import sys
import os

import taggist.indexer

class ExuberantCtagsIndexer(taggist.indexer.Indexer):
    def index(self):
        print('ExuberantCtagsIndexer.index')

def indexer_init(arggroup):
    arggroup.add_argument('--exuberant-ctags-bin', default='ctags')
    return ExuberantCtagsIndexer
