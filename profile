# The following lines were added by Docker Desktop to add commands to your PATH.
export PATH="$PATH:/Users/sathu_sk/.docker/bin"
# End of Docker Desktop section.

# ~/.profile

export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# If running bash, source ~/.bashrc if present and readable. Important when
# opening new panes and windows in tmux for example.
if [ -n "$BASH_VERSION" ]; then
	if [ -r ~/.bashrc ]; then
		. ~/.bashrc
	fi
fi
