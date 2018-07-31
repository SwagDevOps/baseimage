# -*- coding: utf-8 -*-
# vim: ft=sh

# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

export USER=${USER-$(whoami)}
export HOSTNAME=${HOSTNAME-$(hostname)}
export PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'

shopt -s histappend
export HISTCONTROL='ignoreboth,ignoredups'
export HISTSIZE=1000
export HISTFILESIZE=2000
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
shopt -s dotglob # files beginning with . returned in path-name expansion.

# enable color support
test -x /usr/bin/dircolors && {
    eval "$(dircolors -b)"
}

alias ls='ls --color=auto'
/usr/bin/env grep --help | grep -q 'gnu\.org' 2> /dev/null && {
    unalias grep fgrep egrep &> /dev/null

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
}
