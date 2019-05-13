The [Chinese version](#-1) is below the English version.

[中文版](#-1)在英文版下面。

Taggist
=======

Introduction
------------

Taggist is a simple tags and cscope xref file auto-updater plugin for Vim. It
makes it unnecessary to manually manage the tags and the cscope xref file.

Taggist can:

* read the list of the source files and include directories from a Taggist
  project file;
* resolve the dependencies of each source file and tag them;
* update the tags incrementally;
* update the tags and the cscope xref file periodically at the
  background without user attention.

The tools listed below are required for using Taggist:

* [Vim](http://www.vim.org) 7.x with Python 2.7 or 3.x support
* [Python](http://www.python.org) 2.7 or 3.x
* [Exuberant Ctags](http://ctags.sourceforge.net)
* [Cscope](http://cscope.sourceforge.net) (GNU Global may be supported in the
  future.)

You may also like to use the following plugins with this plugin together:

* The [key mappings from Cscope's official website](http://cscope.sourceforge.net/cscope_maps.vim).
  See the [official tutorial](http://cscope.sourceforge.net/cscope_vim_tutorial.html)
  for the usage of cscope with Vim.
* [OmniCppComplete](http://www.vim.org/scripts/script.php?script_id=1520)

Installation
------------

It is recommended to use [pathogen.vim](https://github.com/tpope/vim-pathogen)
to manage your Vim's plugins. You can clone the repo into your `bundle`
directory:

    cd ~/.vim/bundle
    git clone https://github.com/brglng/taggist.vim.git

If you do not use pathogen, you can just clone the repo and copy everything
into `~/.vim`, and then execute `:helptags`.

Usage
-----

1. Create a Taggist project file in your project's working directory.
   `.vim_taggist` is the default name. (on Windows, `_vim_taggist` can also
   be used.) The Taggist project file is written as a python dictionary
   containing the list of source files and include directories. A simplist
   Taggist project file can be like this:

    ```python
    {
        # list each language's include directories here
        'include_dirs': {
            'c':    ['include0', 'include1'],
            'c++':  ['include2']
        },

        # list each language's source files here
        'source_files': {
            'c':    ['*.c'],
            'c++':  ['*.cpp']
        }
    }
    ```

    For details on the Taggist project file, please refer to `:help taggist`
    in Vim and the `.vim_taggist` file in the example.

2. Open Vim, cd to your project's working directory, and call the
   `:TaggistStart` command. If the Taggist project file's name is not
   `.vim_taggist`, use `:TaggistStart <name_of_the_project_file>`. If the
   command succeeded, Taggist now will periodically update the tags and the
   cscope xref file, and add them to Vim.

3. When you want to change to another project, just call `:TaggistStart`
   again. When you want to stop the auto-updating, call the `:TaggistStop`
   command.

Change Log
----------

v0.1.0 (12/2/2013):
* The first release of Taggist.

License
-------

Taggist is licensed under the
[GNU LGPL](http://www.gnu.org/copyleft/lesser.html).


中文版
======

简介
----

Taggist 是一个简单的 Vim 插件，用于为你的项目自动更新的 tags 和 cscope 数据库，
使你无需再手动维护 tags 和 cscope 数据库。

Taggist 可以：

* 从一个 Taggist project 文件读取项目的源码文件和 include 目录列表；
* 分析每个源码文件的依赖性，并为它们做 tag；
* 增量式地更新 tags 文件；
* 在后台每隔一段时间自动更新 tags 和 cscope 数据库，无需人工干预。

Taggist 依赖于以下工具：

* 带有 Python 2.7 或 3.x 支持的 [Vim](http://www.vim.org)
* [Python](http://www.python.org) 2.7 or 3.x
* [Exuberant Ctags](http://ctags.sourceforge.net)
* [Cscope](http://cscope.sourceforge.net)（将来可能支持 GNU Global）

你可能希望将 Taggist 与以下插件一起使用：

* [Cscope 官方网站的键绑定插件](http://cscope.sourceforge.net/cscope_maps.vim).
  可以参考[官方教程](http://cscope.sourceforge.net/cscope_vim_tutorial.html)
  了解在 Vim 中使用 Cscope 的方法。
* [OmniCppComplete](http://www.vim.org/scripts/script.php?script_id=1520)

安装
----

推荐使用 [pathogen.vim](https://github.com/tpope/vim-pathogen) 来管理你的 Vim
插件。你可以把 Taggist 的 repo 克隆到你的 `bundle` 目录：

    cd ~/.vim/bundle
    git clone https://github.com/brglng/taggist.vim.git

如果你不使用 pathogen，可以直接克隆 Taggist repo，然后把所有文件复制到
`~/.vim`，然后执行 `:helptags`。

使用方法
--------

1. 在你的项目的工作目录创建一个 Taggist project 文件。默认的文件名是
   `.vim_taggist`（在 Windows 上也可以使用 `_vim_taggist`）。Taggist project
   文件是一个文本文件，其中包含一个 python dict，用于列出源码文件以及 include
   目录等。一个最简单的 Taggist project 文件可以像这样写：

    ```python
    {
        # 在这里列出对应每一种语言的 include 目录
        'include_dirs': {
            'c':    ['include0', 'include1'],
            'c++':  ['include2']
        },

        # 在这里列出每一种语言的源码文件
        'source_files': {
            'c':    ['*.c'],
            'c++':  ['*.cpp']
        }
    }
    ```

   更详细的 Taggist project 文件写法请参考 `:help taggist` 以及 example 中的
   `.vim_taggist` 文件。

2. 打开 Vim， cd 到你项目的工作目录，然后执行 `:TaggistStart`。如果 Taggist
   project 文件的名字不是 `.vim_taggist`，可以使用
   `:TaggistStart <name_of_the_project_file>`。如果命令成功，Taggist 将开始在
   后台每隔一定时间更新 tags 和 cscope 数据库，并且把它们加入 Vim。

3. 如果要切换到另一个 project，再次执行 `:TaggistStart` 即可。如果要停止自动更
   新，可以执行 `:TaggistStop`。

版本历史
--------

v0.1.0 (2013/12/2):
* Taggist 第一个版本。

许可证
------

Taggist 使用 [GNU LGPL](http://www.gnu.org/copyleft/lesser.html) 许可证。
