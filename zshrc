export PATH=$HOME/bin:$PATH
export EDITOR=vim
export PDFVIEWER=mupdf

# Lines configured by zsh-newuser-install
setopt histignorealldups share_history
HISTFILE=~/.histfile
HISTSIZE=50000
SAVEHIST=50000
setopt appendhistory
bindkey -v
export KEYTIMEOUT=1

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

bindkey '\e.' insert-last-word
bindkey '^[[1;5A' history-beginning-search-backward
bindkey '^[[1;5B' history-beginning-search-forward
autoload -Uz copy-earlier-word
zle -N copy-earlier-word
bindkey '^[,' copy-earlier-word

alias ls="ls --color=auto"
alias l="ls"
alias ll="ls -l"
alias lh="ls -lh"
alias grep="grep --color=auto"
alias gus="git status"
#alias ssh="TERM=xterm-256color ssh"

autoload -U colors; colors
fpath=("$HOME/.zfunctions" $fpath)
autoload -U promptinit; promptinit
prompt pure
PURE_CMD_MAX_EXEC_TIME=0.5

if test -f /etc/arch-release
then
	if test $(($(date +%s) - 3600*24*7)) \
	    -gt $(stat -c %Y /var/lib/pacman/sync)
	then
	    echo "/!\\ pacman repos haven't been synced in over a week"
	fi
fi

print_proxy () {
	printf 'http_proxy=%s\n' "$http_proxy"
	printf 'HTTP_PROXY=%s\n' "$HTTP_PROXY"
	printf 'https_proxy=%s\n' "$https_proxy"
	printf 'HTTPS_PROXY=%s\n' "$HTTPS_PROXY"
	printf 'no_proxy=%s\n' "$no_proxy"
	printf 'NO_PROXY=%s\n' "$NO_PROXY"
}

proxy () {
	if ((# != 1))
	then
		print_proxy
		return
	fi
	case $1 in
		on )
			export http_proxy=http://w3p2.atos-infogerance.fr:8080
			export HTTP_PROXY=$http_proxy
			export https_proxy=$http_proxy
			export HTTPS_PROXY=$http_proxy
			export no_proxy=bull.fr,ao-srv.com
			export NO_PROXY=$NO_PROXY
			print_proxy
			;;
		off )
			export http_proxy=
			export HTTP_PROXY=$http_proxy
			export https_proxy=$http_proxy
			export HTTPS_PROXY=$http_proxy
			export no_proxy=
			export NO_PROXY=$no_proxy
			print_proxy
			;;
		* )
			echo "invalid command"
			;;
	esac
}
