#!python
import os
import subprocess
import fnmatch

# this function is used by Cscope and GNU Global only
def includes():
    """Returns all the include directories."""

    # find all the directories recursively
    incs = []
    for root, dirnames, filenames in os.walk(os.curdir):
        incs.append(root)

    return incs

# this function is used by Exuberant-Ctags only
def dependency(filename):
    """Returns the dependency of one single source file."""

    # find the dependency with gcc -M
    gcc_args = ['gcc', '-M']
    for inc in includes():
        gcc_args.append('-I')
        gcc_args.append(inc)
    gcc_args.append(filename)

    output = subprocess.check_output(gcc_args)
    output = output.replace(' \\\n', ' ').replace(' \\\r\n', ' ').partition(':')[2].split()

    return output

# this function is used by all indexers
def sources():
    """Returns all the source files"""

    # find *.c recursively
    srcs = []
    for root, dirnames, filenames in os.walk(os.curdir):
        for filename in fnmatch.filter(filenames, '*.c'):
            srcs.append(os.path.join(root, filename))

    return srcs
