#!python
import os
import sys
import argparse
import imp
import random
import string
import glob
import math

import taggist.vimclient

def _random_name():
    """Generates a random module name."""
    return random.choice(string.ascii_letters + '_') + ''.join(random.choice(string.ascii_letters + string.digits + '_') for x in range(int(math.log(2**256, 26*2 + 11)) + 1))

def load_module(filename):
    """Load and return a module contained in a file."""
    if not filename:
        return None

    module = imp.load_source(_random_name(), filename)

    return module

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--vim-bin', default='vim')
    parser.add_argument('--vim-server-name', required=True)
    parser.add_argument('--interval', default=30, type=int)
    parser.add_argument('--config-file', default='.taggist.py')
    parser.add_argument('--indexers')

    # load the indexer plugins
    indexers_dir = os.path.join(os.path.dirname(__file__), 'taggist', 'indexers')
    indexer_classes = {}
    for indexer_py in glob.glob(os.path.join(indexers_dir, '*.py')):
        indexer_module = load_module(indexer_py)
        indexer_name = os.path.splitext(os.path.basename(indexer_py))[0]
        indexer_classes[indexer_name] = indexer_module.indexer_init(parser.add_argument_group(indexer_name))

    args = parser.parse_args()

    # find the config file in current directory and parent directories
    config_file = args.config_file
    while not os.path.exists(config_file):
        if os.path.realpath(config_file) == os.path.realpath(os.path.join('/', args.config_file)):
            print(parser.prog + ': File ' + args.config_file + ' cannot be found in current directory or parent directories.')
            sys.stdout.flush()
            sys.exit(-1)
        config_file = os.path.join('..', config_file)

    # chdir to the directory containing the config file
    config_file_dir = os.path.dirname(config_file)
    if config_file_dir:
        os.chdir(os.path.dirname(config_file))

    # load the config file now
    config = load_module(args.config_file)

    # start the Vim client
    vim_client = taggist.vimclient.VimClient(servername=args.vim_server_name, vim_bin=args.vim_bin)

    # initialize an unsafe thread pool
    enabled_indexers = args.indexers.split(',')
    indexer_pool = []
    for (indexer_name, indexer_class) in indexer_classes.items():
        if indexer_name in enabled_indexers:
            indexer_pool.append(indexer_class(interval=args.interval, config=config, vim_client=vim_client, cmdargs=args))

    # start all the Indexer threads
    for indexer in indexer_pool:
        indexer.daemon = True
        indexer.start()

    sys.stderr.write('taggistd started\n')

    while True:
        pass
