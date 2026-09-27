# ~/.bashrc

# Return early if not running in interactive mode.
[[ $- != *i* ]] && return

# Use UTF-8 locale with C collation order for predictable sorting.
export LANG=C.UTF-8
export LC_COLLATE=C

# Ghostty shell integration
if [ -n "${GHOSTTY_RESOURCES_DIR}" ]; then
    builtin source "${GHOSTTY_RESOURCES_DIR}/shell-integration/bash/ghostty.bash"
fi

eval "$(starship init bash)"
eval "$(/opt/homebrew/bin/brew shellenv)"

# Prepend ~/bin, ~/.local/bin and /usr/local/bin to PATH.
export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH"

# Prepend ~/.local/share/man and /usr/local/share/man to the man search
# path. Note the trailing colon to preserve system defaults.
export MANPATH="$HOME/.local/share/man:/usr/local/share/man:"

# Remove delay after ESC in ncurses applications. For example, fzf will
# quit immediately after hitting ESC instead of waiting.
export ESCDELAY=0

# Prefer nvim when applications want to launch an editor.
export VISUAL=nvim
export EDITOR=nvim

# Set default pager to less, and in less preserve colors and formatting,
# clear screen before displaying new page and use smarte-case search.
export PAGER=less
export LESS=Rci

# Enable parallel compilation with make.
export MAKEFLAGS="-j $(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || printf 1)"

# GPG needs to know which terminal to use when prompting for
# passphrases.
export GPG_TTY=$(tty)

# Report the current directory via OSC 7, add OSC 133 shell markers, and
# color the user and hostname green for regular users or red for root.
PS1="\[\e]7;file://\h\$PWD\a\]\[\e]133;A\a\]\[\e[$((EUID ? 32 : 31));1m\]\u@\h\[\e[0m\]:\[\e[34;1m\]\w\[\e[0m\]\$ \[\e]133;B\a\]"

# Remember up to this number of prior commands in the shell history
# file.
HISTSIZE=65535

# Aliases.
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

# Source bash completion from the appropriate location if available, and
# if it hasn't already been sourced.
if [[ -z $BASH_COMPLETION_VERSINFO ]]; then
	if [[ -r /usr/share/bash-completion/bash_completion ]]; then
		. /usr/share/bash-completion/bash_completion
	elif [[ -n ${HOMEBREW_PREFIX-} &&
		-r "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]]; then
		. "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
	fi
fi

# Append OpenCode bin to PATH.
export PATH=/Users/sathu_sk/.opencode/bin:$PATH
