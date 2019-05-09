#!/usr/bin/env python3

from os import path
import sys
import subprocess

if __name__ == '__main__':
    cmdline = ['nvim', '-f']

    if path.isdir(sys.argv[1]) and path.isdir(sys.argv[1]):
        cmdline.extend([
            ('+DirDiff %s %s' % (sys.argv[1], sys.argv[2])),
        ])
    else:
        cmdline.extend([
            '+e ' + sys.argv[1],
            '+vert diffsplit ' + sys.argv[2],
        ])

    sys.exit(subprocess.call(cmdline))
