export PATH=$PATH:$HOME/bin
export EDITOR=vim

# Lines configured by zsh-newuser-install
setopt histignorealldups share_history
HISTFILE=~/.histfile
HISTSIZE=50000
SAVEHIST=50000
setopt appendhistory
bindkey -v

bindkey '\e.' insert-last-word
bindkey '^[[1;5A' history-beginning-search-backward
bindkey '^[[1;5B' history-beginning-search-forward
autoload -Uz copy-earlier-word
zle -N copy-earlier-word
bindkey '^[,' copy-earlier-word

alias ls="ls --color=auto"
alias ll="ls -l"
alias lh="ls -lh"
alias gus="git status"
#alias ssh="TERM=xterm-256color ssh"

autoload -U colors; colors
fpath=("$HOME/.zfunctions" $fpath)
autoload -U promptinit; promptinit
prompt pure
PURE_CMD_MAX_EXEC_TIME=0.5

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

export CDRIVE=/mnt/c
export CDRIVE_HOME="$CDRIVE/Users/A650138"
c () {
	cd "$CDRIVE"
}
chome () {
    cd "$CDRIVE_HOME"
}
