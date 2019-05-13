#!python

from collections import deque
import os
import platform
import subprocess
import re
import glob
import time
import threading
import string

__version__ = "0.1.0"

_DEBUG = False
_logfilename = ('vim-taggist-' + str(time.time()) + '.log')

def _LOG(s):
    if _DEBUG:
        with open(_logfilename, 'a') as logfile:
            logfile.write(str(time.time()) + ': ' + s + '\n')

_charset_fallback_list = ['UTF-8', 'UTF-16LE', 'UTF-16BE', 'UTF-32LE', 'UTF-32BE', 'GB18030', 'BIG5', 'EUC-JP', 'SHIFT-JIS', 'EUC-KR', 'LATIN-1']
def _decode_readlines(filename):
    f = open(filename, 'rb')
    s = f.read()
    f.close()

    is_binary = True

    #for charset_name in _charset_fallback_list:
    #    try:
    #        lines = s.decode(charset_name).splitlines(True)
    #        is_binary = False
    #        break
    #    except UnicodeDecodeError:
    #        pass

    if is_binary:
        lines = str(filter(lambda x: x in string.printable, s)).splitlines(True)

    return lines

def _conv_ft_name(langname):
    """ Convert language names.

    This is needed because python function names cannot contain such
    strings as 'c++' or 'c#', but those are used by vim and ctags. """
    langname = langname.lower()
    if langname == 'c++':
        return 'cpp'
    elif langname == 'c#':
        return 'csharp'
    else:
        return langname

def find_dependency_c(filename, incdirs_names=[]):
    """ Find the dependencies of a C source file. """

    pattern0 = re.compile(r'^\s*#\s*include\s*<([^>]+)>\s*$')
    pattern1 = re.compile(r'^\s*#\s*include\s*"([^"]+)"\s*$')

    #pattern0 = re.compile(r'^\s*#\s*include\s*(<[^>]+>|"[^"]+")\s*$')
    #pattern1 = re.compile(r'(^\s*#\s*include\s*("[^"]+|<[^>]+)?)\\\s*$')
    #pattern2 = re.compile(r'([^"]+"|[^>]+>)\s*$')
    #pattern3 = re.compile(r'(.*)\\\s*$')

    # do the broadth-first-search (BFS)
    if os.access(filename, os.R_OK) and not os.path.isdir(filename):
        # the first file should not be tested with incdirs
        srcfile_name = filename
        srcfile_readible = True

        queue = deque()
        depfiles_names = []
        incdirs_names = [os.path.dirname(filename)] + incdirs_names
    else:
        return []

    while True:
        # ignore if the file already in the list
        if srcfile_readible and srcfile_name not in depfiles_names:
            depfiles_names.append(srcfile_name)

            #state = 0
            #lastline = ''
            for line in _decode_readlines(srcfile_name):
                match_obj = pattern0.search(line)
                if match_obj:
                    include_file_name = match_obj.groups()[0]
                    queue.append(include_file_name)
                else:
                    match_obj = pattern1.search(line)
                    if match_obj:
                        include_file_name = match_obj.groups()[0]
                        queue.append(include_file_name)

                # here is a state machine
                #if state == 0:
                #    match_obj = pattern0.search(line)
                #    if match_obj:
                #        include_file_name = match_obj.groups()[0][1:-1]
                #        queue.append(include_file_name)
                #    else:
                #        match_obj = pattern1.search(line)
                #        if match_obj:
                #            lastline = match_obj.groups()[0]
                #            state = 1
                #elif state == 1:
                #    match_obj = pattern2.search(line)
                #    if match_obj:
                #        lastline = lastline + match_obj.groups()[0]
                #        match_obj = pattern0.search(lastline)
                #        if match_obj:
                #            include_file_name = match_obj.groups()[0][1:-1]
                #            queue.append(include_file_name)
                #        state = 0
                #    else:
                #        match_obj = pattern3.search(line)
                #        if match_obj:
                #            lastline = lastline + match_obj.groups()[0]
                #        else:
                #            state = 0

        if not queue:
            break

        srcfile_name = queue.popleft()
        srcfile_readible = False
        for incdir_name in incdirs_names:
            srcfile_name_new = os.path.join(incdir_name, srcfile_name)
            if os.access(srcfile_name_new, os.R_OK) and not os.path.isdir(srcfile_name_new):
                srcfile_name = srcfile_name_new
                srcfile_readible = True
                break   # use only the first found one

    return depfiles_names

def find_dependency_cpp(filename, incdirs_names=[]):
    """ Find the dependencies of a C++ source file. """
    return find_dependency_c(filename, incdirs_names)

def find_dependency(lang, filename, incdirs_names=[]):
    if ('find_dependency_' + _conv_ft_name(lang)) in globals().keys():
        return globals()['find_dependency_' + _conv_ft_name(lang)](filename, incdirs_names)
    else:
        return filename

def remove_files_tags(tags_file_name, filenames):
    """ Remove the tags of source files in a tags file. """
    tags_file_mtime = os.path.getmtime(tags_file_name)

    tags_file = open(tags_file_name, "r")
    lines = tags_file.readlines()
    tags_file.close()

    lines_new = [l for l in lines if l[0] == '!' or not (l.split('\t')[1] in filenames)]

    tags_file = open(tags_file_name, "w")
    tags_file.writelines(lines_new)
    tags_file.close()

    # this function should not change the tags file's timestamp
    os.utime(tags_file_name, (os.path.getatime(tags_file_name), tags_file_mtime))

def get_tagged_files_names(tags_file_name):
    """ Get the files that are tagged in a tags file. """
    with open(tags_file_name, 'r') as tags_file:
        tagged_files_names = [line.split('\t')[1] for line in tags_file if line[0] != '!']

    return tagged_files_names

def remove_redundant_tags(tags_file_name, known_files_names):
    """ Remove tags of files not in known_files_names from the tags file. """
    prev_files_names = set(get_tagged_files_names(tags_file_name))
    removed_files_names = prev_files_names - set(known_files_names)

    _LOG('vim_taggist.remove_redundant_tags: removed_files_names: ' + repr(removed_files_names))

    if removed_files_names:
        remove_files_tags(tags_file_name, removed_files_names)

def _spawn_silently(args):
    """ Call and wait for a subprocess silently. """
    if platform.system() == 'Windows':
        if _DEBUG:
            return subprocess.check_call(args)
        else:
            si = subprocess.STARTUPINFO()
            si.dwFlags = subprocess.STARTF_USESHOWWINDOW
            si.wShowWindow = subprocess.SW_HIDE
            p = subprocess.Popen(args, shell=False, bufsize=-1, startupinfo=si, creationflags=subprocess.CREATE_NEW_CONSOLE)
            return p.wait()
    else:
        if _DEBUG:
            return subprocess.check_call(args)
        else:
            return subprocess.call(args, stdin=open(os.devnull, 'rb'), stdout=open(os.devnull, 'wb'), stderr=open(os.devnull, 'wb'))

default_project_dict = {
    'include_dirs': {'c': [], 'c++': []},
    'source_files': {'c':     ['*.c'],
                     'c++':   ['*.cc', '*.cxx', '*.cpp']},

    'ctags_exe': 'ctags',
    'ctags_args': [],
    'tags_file_name': 'tags',

    'cscope_exe': 'cscope',
    'cscope_args': [],
    'cscope_out_file_name': 'cscope.out'
}

class Project(object):
    """ The Project class. """

    def __init__(self, project_dict=None):
        """ Initialize a Project object with a dict.
        If some key does not exist in the dict, the default value is used. """

        self.__dict__ = default_project_dict.copy()
        if project_dict is not None:
            for (k, v) in project_dict.items():
                self.__dict__[k] = v
                if k == 'include_dirs':
                    for (kk, vv) in default_project_dict[k].items():
                        if kk in self.__dict__[k].keys():
                            self.__dict__[k][kk].extend(vv)

    def update_tags(self):
        """ Update the project's tags file. """

        _LOG('vim_taggist.Project.update_tags: update_tags: started')

        lang_files_names = {}
        for (lang, globs) in self.source_files.items():
            srcfiles_names = [filename for g in globs
                                           for filename in glob.glob(g)]

            incdirs_names = []
            for g in self.include_dirs[lang]:
                for d in glob.glob(g):
                    if os.path.isdir(d) and d not in incdirs_names:
                        incdirs_names.append(d)

            _LOG('vim_taggist.Project.update_tags: srcfiles_names: ' + repr(srcfiles_names))
            _LOG('vim_taggist.Project.update_tags: incdirs_names: ' + repr(incdirs_names))

            lang_files_names[lang] = []
            for filename in srcfiles_names:
                for f in find_dependency(lang, filename, incdirs_names):
                    if f not in lang_files_names[lang]:
                        lang_files_names[lang].append(f)

        _LOG('vim_taggist.Project.update_tags: lang_files_names: ' + repr(lang_files_names))

        all_files_names = [f for filenames in lang_files_names.values() for f in filenames]

        _LOG('vim_taggist.Project.update_tags: all_files_names: ' + repr(all_files_names))

        if os.path.exists(self.tags_file_name):
            remove_redundant_tags(self.tags_file_name, all_files_names)

        tags_file_mtime = os.path.getmtime(self.tags_file_name) if os.path.exists(self.tags_file_name) else 0
        tags_file_mtime_new = time.time()
        tagged_files_names = []

        ret = 0
        for (lang, filenames) in lang_files_names.items():
            changed_files_names = []
            for f in filenames:
                if os.path.getmtime(f) > tags_file_mtime:
                    changed_files_names.append(f)
                else:
                    if not tagged_files_names:
                        tagged_files_names = get_tagged_files_names(self.tags_file_name)
                    if not (f in tagged_files_names):
                        changed_files_names.append(f)
                        tagged_files_names.append(f)

            _LOG('vim_taggist.Project.update_tags: changed_files_names: ' + repr(changed_files_names) + '\n'
                  'vim_taggist.Project.update_tags: tagged_files_names: ' + repr(tagged_files_names))

            if tags_file_mtime != 0 and changed_files_names:
                _LOG('vim_taggist.Project.update_tags: removing tags of these files: ' +
                      repr(changed_files_names) + ' from this tags file: ' + self.tags_file_name)
                remove_files_tags(self.tags_file_name, changed_files_names)

            if changed_files_names:
                ctags_opt_file_name = self.tags_file_name + '.files'

                with open(ctags_opt_file_name, 'w') as ctags_opt_file:
                    ctags_opt_file.write('\n'.join(changed_files_names))
                    ctags_opt_file.write('\n')

                call_ctags_cmd = [self.ctags_exe]
                call_ctags_cmd.extend(self.ctags_args)
                call_ctags_cmd.extend(['-a',
                                       '-f',
                                       self.tags_file_name])
                call_ctags_cmd.extend(['-L', ctags_opt_file_name])

                _LOG('vim_taggist.Project.update_tags: call_ctags_cmd: ' +
                      repr(call_ctags_cmd))

                ret = _spawn_silently(call_ctags_cmd)
            else:
                _LOG('vim_taggist.Project.update_tags: no file changed')

            if changed_files_names and os.path.exists(self.tags_file_name):
                os.utime(self.tags_file_name, (os.path.getatime(self.tags_file_name), tags_file_mtime_new))

            if ret != 0:
                break

        return ret

    def update_cscope_db(self):
        """ Update the project's cscope database file. """

        _LOG('vim_taggist: update_cscope_db: started')

        all_srcfiles_names = [f for globs in self.source_files.values()
                                    for g in globs
                                        for f in glob.glob(g)]

        all_incdirs_names = []
        for globs in self.include_dirs.values():
            for g in globs:
                for d in glob.glob(g):
                    if os.path.isdir(d) and not d in all_incdirs_names:
                        all_incdirs_names.append(d)

        cscope_opt_file_name = self.cscope_out_file_name + '.files'

        call_cscope_cmd = [self.cscope_exe]
        call_cscope_cmd.extend(self.cscope_args)
        call_cscope_cmd.extend(['-b', '-f', self.cscope_out_file_name])
        #call_cscope_cmd.extend([('-I' + d) for d in all_incdirs_names])
        #call_cscope_cmd.extend(all_srcfiles_names)
        call_cscope_cmd.extend(['-i', cscope_opt_file_name])

        _LOG('vim_taggist.Project.update_cscope_db: call_cscope_cmd: ' + repr(call_cscope_cmd))

        with open(cscope_opt_file_name, 'w') as cscope_opt_file:
            cscope_opt_file.write('-I')
            cscope_opt_file.write('\n-I'.join(all_incdirs_names))
            cscope_opt_file.write('\n')
            cscope_opt_file.write('\n'.join(all_srcfiles_names))
            cscope_opt_file.write('\n')

        ret = _spawn_silently(call_cscope_cmd)

        return ret

class Timer(threading.Thread):
    'Call a function periodically, with an interval set by the user.'

    _event = threading.Event()

    def __init__(self, interval, function, args=[], kwargs={}):
        threading.Thread.__init__(self)
        self._interval = interval
        self._function = function
        self._args = args
        self._kwargs = kwargs
        self._event = threading.Event()

    def run(self):
        while not self._event.is_set():
            self._function(*self._args, **self._kwargs)
            self._event.wait(self._interval)

    def stop(self):
        self._event.set()
