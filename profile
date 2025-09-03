# ~/.profile

export PATH=$HOME/bin:$HOME/.local/bin:$PATH

# If running bash, source ~/.bashrc if present and readable. Important when
# opening new panes and windows in tmux for example.
if [ -n "$BASH_VERSION" ]; then
	if [ -r ~/.bashrc ]; then
		. ~/.bashrc
	fi
fi
