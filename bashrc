# ~/.bashrc

export LANG=C.UTF-8
export LC_COLLATE=C

# Return early if not running in interactive mode.
[[ $- != *i* ]] && return

eval "$(/opt/homebrew/bin/brew shellenv)"

# Prepend ~/bin, ~/.local/bin and /usr/local/bin to PATH.
export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH"

# Prepend ~/.local/share/man and /usr/local/share/man to the man search
# path. Note the trailing colon.
export MANPATH="$HOME/.local/share/man:/usr/local/share/man:"

# Remove delay after ESC in ncurses applications. For example, fzf will
# quit immediately after hitting ESC instead of waiting for a bit.
export ESCDELAY=0

# Prefer nvim when applications want to launch an editor.
export VISUAL=nvim
export EDITOR=nvim

# Set default pager to less, and in less preserve colors and formatting,
# clear screen befpre displaying new page and use smarte-case search.
export PAGER=less
export LESS=Rci

# Enable parallel compilation with make.
#export MAKEFLAGS="-j $(nproc)"
export MAKEFLAGS="-j $(sysctl -n hw.ncpu)"

# GPG needs to know which terminal to use when prompting for
# passphrases.
export GPG_TTY=$(tty)

# Set the prompt, and also mark prompt boundaries and have color green
# for regular users and red for root.
PS1="\[\e]133;A\a\]\[\e[$((EUID ? 32 : 31));1m\]\u@\h\[\e[0m\]:\[\e[34;1m\]\w\[\e[0m\]\$ \[\e]133;B\a\]"

# Remember up to this number of prior commands in the shell history
# file.
HISTSIZE=65535

# Set some handy aliases.
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias temp='cd $(mktemp -d) && pwd'
alias ssh='TERM=xterm-256color ssh'
alias grep='grep --color=auto'
alias rg='rg -Nuu --no-heading'
alias fd='fd -uc never'
alias tree='tree -F'
alias ip='ip -c=auto'
alias nv='nvim'
alias ls='ls --color=auto'
alias l='ls -la --color=auto'
alias g='git'

diff() {
	if [ -t 1 ]; then
		command diff -u --color=always "$@" | less
	else
		command diff -u "$@"
	fi
}

# Source bash_completion if it is installed and hasn't already been
# sourced.
#[[ -z $BASH_COMPLETION_VERSINFO &&
#	-r /usr/share/bash-completion/bash_completion ]] &&
#	. /usr/share/bash-completion/bash_completion
[[ -z $BASH_COMPLETION_VERSINFO &&
	-r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]] &&
	. "$(brew --prefix)/etc/profile.d/bash_completion.sh"
