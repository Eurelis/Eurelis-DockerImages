#
# .bashrc
#
export PS1="\[\033[38;5;9m\][\[$(tput sgr0)\]\[\033[38;5;11m\]\u\[$(tput sgr0)\]\[\033[38;5;9m\]@\[$(tput sgr0)\]\[\033[38;5;14m\]container\[$(tput sgr0)\]\[\033[38;5;9m\]]\[$(tput sgr0)\]\[\033[38;5;15m\]:\[$(tput sgr0)\]\[\033[38;5;10m\]\W\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;9m\]\\$\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]"

alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

if [ -f /opt/.mybashrc ]; then
  source /opt/.mybashrc
fi

echo "*********************************************"
echo "*"
echo "* Image : ubuntu-php8"
echo -n "* "
head -n 1 /etc/version
echo "*"
echo "*********************************************"

