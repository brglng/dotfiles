#!/usr/bin/env python
import subprocess
import time
from threading import Thread
import sys

def reader(f):
    while True:
        line = f.read()
        if not line:
            break
        sys.stdout.write(line)
        sys.stdout.flush()

cs = subprocess.Popen(['cscope', '-l'], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)#, bufsize=1)

cst1 = Thread(target=reader, kwargs={'f': cs.stdout})
cst1.daemon = True

#cst2 = Thread(target=reader, kwargs={'f': cs.stderr})
#cst2.daemon = True

cst1.start()
#cst2.start()

cs.stdin.write('1dtsSegmentFrame\n')
cs.stdin.write('q\n')

cs.wait()
