source ~/.bashrcu
# shellcheck shell=bash
# shellcheck disable=SC2034

# If not running interactively, don't do anything
case $- in
	*i*) ;;
	*) return ;;
esac

# Path to the bash it configuration
BASH_IT="/home/tariq/.bash_it"

# Lock and Load a custom theme file.
# Leave empty to disable theming.
# location "$BASH_IT"/themes/
export BASH_IT_THEME='simple'

# Don't check mail when opening terminal.
unset MAILCHECK

# Change this to your console based IRC client of choice.
export IRC_CLIENT='irssi'

# Set this to the command you use for todo.txt-cli
TODO="t"

# History suggestions

# 1. Immediately show all options if a tab complete is ambiguous
bind 'set show-all-if-ambiguous on'
# Enable immediate color coding for matches
bind 'set colored-stats on'

# Instantly color the common prefix of matches when ambiguous
bind 'set colored-completion-prefix on'
# 2. Cycle through the choices on subsequent tab clicks rather than just listing them
bind 'set menu-complete-display-prefix on'
bind '"\t": menu-complete'

# 3. Type part of a past command and press Up/Down to search matching history items
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'


# Load Bash It
source "${BASH_IT?}/bash_it.sh"
