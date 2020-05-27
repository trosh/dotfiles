export PATH=$HOME/bin:$PATH
export XDG_DATA_DIRS=/usr/local/share/:/usr/share/:$HOME/.fwddesktop/
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
bindkey -s '^L' '^Utest $((RANDOM%6)) -eq 0 && timeout 6 cbeams -o;clear\n'
autoload -Uz copy-earlier-word
zle -N copy-earlier-word
bindkey '^[,' copy-earlier-word

alias ls="ls --color=auto"
alias l="ls"
alias ll="ls -l"
alias lh="ls -lh"
alias grep="grep --color=auto"
#alias ssh="TERM=xterm-256color ssh"

autoload -U colors; colors
fpath=("$HOME/.zfunctions" $fpath)
autoload -U promptinit; promptinit
prompt clint
#prompt pure
#PURE_CMD_MAX_EXEC_TIME=0.5
#PURE_PROMPT_SYMBOL='>'
#PURE_PROMPT_VICMD_SYMBOL='<'
#PURE_GIT_DOWN_ARROW='v'
#PURE_GIT_UP_ARROW='^'
#PURE_GIT_STASH_SYMBOL='#'

if test -f /etc/arch-release
then
	if test $(($(date +%s) - 3600*24*7)) \
	    -gt $(stat -c %Y /var/lib/pacman/sync)
	then
	    echo "/!\\ pacman repos haven't been synced in over a week"
	fi
fi

print_proxy () {
	printf '\033[7mhttp_proxy\033[m\t%s\n' "$http_proxy"
	printf '\033[7mHTTP_PROXY\033[m\t%s\n' "$HTTP_PROXY"
	printf '\033[7mhttps_proxy\033[m\t%s\n' "$https_proxy"
	printf '\033[7mHTTPS_PROXY\033[m\t%s\n' "$HTTPS_PROXY"
	printf '\033[7mno_proxy\033[m\t%s\n' "$no_proxy"
	printf '\033[7mNO_PROXY\033[m\t%s\n' "$NO_PROXY"
	printf '\033[7m.gitconfig\033[m\t%s\n' "$(git config --global http.proxy)"
	printf '\033[7mapt.conf\033[m\t%s\n' "$(grep --color=never '^Acquire::http::Proxy' /etc/apt/apt.conf)"
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
			export NO_PROXY=$no_proxy
			git config --global http.proxy "$http_proxy"
			grep '^Acquire::http::Proxy' /etc/apt/apt.conf > /dev/null \
				|| echo "Acquire::http::Proxy \"$http_proxy\";" \
					| sudo tee -a /etc/apt/apt.conf > /dev/null
			print_proxy
			;;
		off )
			export http_proxy=
			export HTTP_PROXY=$http_proxy
			export https_proxy=$http_proxy
			export HTTPS_PROXY=$http_proxy
			export no_proxy=
			export NO_PROXY=$no_proxy
			git config --global --unset http.proxy
			grep '^Acquire::http::Proxy' /etc/apt/apt.conf > /dev/null \
				&& sudo sed -i '/^Acquire::http::Proxy/d' /etc/apt/apt.conf
			print_proxy
			;;
		* )
			echo "invalid command"
			;;
	esac
}
