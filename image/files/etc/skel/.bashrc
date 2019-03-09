# -*- coding: utf-8 -*-
# vim: ft=sh

# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything --------------------
case $- in
    *i*) ;;
      *) return;;
esac

# Profile ------------------------------------------------------------
(f=/etc/profile; test -f "${f}" && test -r "${f}") && {
    . /etc/profile
}

# Environment --------------------------------------------------------
export USER=${USER-$(whoami)}
export HOSTNAME=${HOSTNAME-$(hostname)}
export PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
# History ------------------------------------------------------------
shopt -s histappend
export HISTCONTROL='ignoreboth,ignoredups'
export HISTSIZE=1000
export HISTFILESIZE=2000
# Misc ---------------------------------------------------------------
shopt -s checkwinsize
shopt -s dotglob # files beginning with . returned in path-name expansion.
# In case you miss the command you are searching giving a Ctrl + r,
# you can reverse the search direction by hitting CTRL + s
# However,this is normally mapped to XOFF (interrupt data flow).
# Since that's not too useful any more
# because we're not using slow serial terminals, turn off that mapping with:
stty -ixon

# Colors support -----------------------------------------------------
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

# Editor -------------------------------------------------------------
test -z "$EDITOR" && type -f vim &> /dev/null && {
    export EDITOR=vim
}

# Local Variables:
# mode: Shell-script
# End:
