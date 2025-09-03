# ~/.bashrc

[[ $- != *i* ]] && return

eval "$(/opt/homebrew/bin/brew shellenv)"

export PATH=$HOME/bin:$HOME/.local/bin:$PATH

# Remove delay after ESC in ncurses applications. For example, fzf will quit
# immediately after hitting ESC instead of waiting for a bit.
export ESCDELAY=0

# Prefer nvim when applications want to launch an editor.
export VISUAL=nvim
export EDITOR=nvim

# Set the prompt, and also mark prompt boundaries and have color green for
# regular users and red for root.
PS1="\[\e]133;A\a\]\[\e[$((EUID ? 32 : 31));1m\]\u@\h\[\e[0m\]:\[\e[34;1m\]\w\[\e[0m\]\$ \[\e]133;B\a\]"

# Set some handy aliases.
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias temp='cd $(mktemp -d) && pwd'
alias ssh='TERM=xterm-256color ssh'
alias grep='grep --color=auto'
alias rg='rg -Nuu --no-heading'
alias nv='nvim'
alias ls='ls --color=auto'
alias l='ls -la --color=auto'

# Source bash_completion if it is installed and hasn't already been sourced.
[[ -z $BASH_COMPLETION_VERSINFO &&
	-r /opt/homebrew/etc/profile.d/bash_completion.sh  ]] &&
	. /opt/homebrew/etc/profile.d/bash_completion.sh
