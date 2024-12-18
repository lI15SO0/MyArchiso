# My Archiso Build Scripts

---

## !!WIP!!

WARN: This branch was not finished.

---

## Intro

This scripts based on Docker and Archiso.

I modified something to make it more easier to use for me.

---

## Why using chroot except docker?

Cause I liveing in China. Dockerhub was banned in sometime at 2024. The reason why Docker was banned is USA use Dockerhub as a weapon to attack China. Sad!

So that I can not pull lastest archlinux docker image to build archiso.

Althought dockerhub was unbanned in Chine, but I was decided develope this verson of script.

---

## How it work? (WIP)

Step1: Get archlinux-bootstrap package if chroot enviroment not exist.

Step2: copy scripts from fs to chroot enviroment.

Step3: copy ssh licenses into chroot enviroment.

Step4: run scripts with chroot command to build archiso.

Step5: move archiso out of chroot enviroment.

---

## Dependencies

- curl
- tar
- zstd

---

## What was I modified (WIP)

Switch mirrors to CN.

Include ArchlinuxCN mirrors.

Enable pacman feature: ParallelDownload

Include My [nvim dotfiles](https://github.com/lI15SO0/nvim-config/tree/lsp_not_include).

Modified some software package, more detail see: fs/releng/packages.x86_64

## How to modified this scripts to build you own archiso / How to use this scripts. (WIP)

Step 1: Modify build.lua, Change the setups.

Step 2: Modify fs/releng/* , you can refer to [This Document](https://wiki.archlinux.org/title/Archiso) to modify these files.

Step 3: Modify fs/makefile , to make it fit your build workflow. NOTICE: This script will copy /out out of docker cotainer, so make sure image will save at /out

Step 4: Build archiso via build.lua script. You can also add it to crontab to make it automatic.

## How to contribute this project.

Take issue.

Like some idea. Or bugs.

Or pr.

THX.
