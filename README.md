# My Archiso Build Scripts

---

## Intro

This scripts based on Docker and Archiso.

I modified something to make it more easier to use for me.

## What was I modified

Switch mirrors to CN.

Include ArchlinuxCN mirrors.

Enable pacman feature: ParallelDownload

Include My [nvim dotfiles](https://github.com/lI15SO0/nvim-config/tree/lsp_not_include).

Modified some software package, more detail see: fs/releng/packages.x86_64

## How to modified this scripts to build you own archiso / How to use this scripts.

Step 1: Modify build.lua, Change the setups.

Step 2: Modify fs/releng/* , you can refer to [This Document](https://wiki.archlinux.org/title/Archiso) to modify these files.

Step 3: Modify fs/makefile , to make it fit your build workflow. NOTICE: This script will copy /out out of docker cotainer, so make sure image will save at /out

Step 4: Build archiso via build.lua script. You can also add it to crontab to make it automatic.

## How to contribute this project.

Take issue.

Like some idea. Or bugs.

Or pr.
