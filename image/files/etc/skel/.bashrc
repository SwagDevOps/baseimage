# -*- coding: utf-8 -*-
# vim: ft=sh

# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

shopt -s histappend
export HISTCONTROL='ignoreboth,ignoredups'
export HISTSIZE=1000
export HISTFILESIZE=2000
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
shopt -s dotglob # files beginning with . treturned in path-name expansion.

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
test -x /usr/bin/dircolors && {
    eval "$(dircolors -b)"

    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
}

# make less more friendly for non-text input files, see lesspipe(1)
test -x /usr/bin/lesspipe && {
    eval "$(lesspipe)"
}
