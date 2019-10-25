# Setup a red prompt for root and a green one for users.

NORMAL="\[\e[0m\]"
RED="\[\e[1;31m\]"
GREEN="\[\e[1;32m\]"

case "$(whoami)" in
    root) PS1="$RED\h [$NORMAL\w$RED]# $NORMAL" ;;
    *)    PS1="$GREEN\h [$NORMAL\w$GREEN]\$ $NORMAL" ;;
esac
