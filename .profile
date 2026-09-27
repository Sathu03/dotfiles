# ~/.profile

# Prepend ~/bin, ~/.local/bin and /usr/local/bin to PATH.
export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH"

# On macOS, initialize Homebrew environment if present.
[ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

# Add Docker Desktop commands to PATH.
export PATH="$PATH:/Users/sathu_sk/.docker/bin"

# If running bash, source ~/.bashrc if present and readable. Important
# when opening new panes and windows in tmux for example.
if [ -n "$BASH_VERSION" ]; then
	if [ -r ~/.bashrc ]; then
		. ~/.bashrc
	fi
fi
