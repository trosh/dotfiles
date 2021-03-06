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

alias LESS="--mouse-wheel-lines=4"

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
export LESS="--mouse --wheel-lines=4 --RAW-CONTROL-CHARS --chop-long-lines"

compdef vman="man"

alias sway="MOZ_ENABLE_WAYLAND=1 XDG_CURRENT_DESKTOP=sway sway"
case $TERM in
	xterm*)
		if [ -e /usr/share/terminfo/x/xterm-256color ]
		then
			export TERM=xterm-256color
		elif [ -e /usr/share/terminfo/x/xterm-color ]
		then
			export TERM=xterm-color
		else
			export TERM=xterm
		fi
		;;
	linux)
		if test -n "$FBTERM"
		then
			export TERM=fbterm
		else
			case $(tty) in
				/dev/tty1) startx ;;
				/dev/tty2) sway ;;
				/dev/tty3) FBTERM=1 exec fbterm ;;
			esac
		fi
		;;
esac

autoload -U colors; colors
fpath=("$HOME/.zfunctions" $fpath)
autoload -U promptinit; promptinit
prompt clint

if test -f /etc/arch-release
then
	pacdate=$(stat -c %Y /var/lib/pacman/sync)
	if test $(($(date +%s) - 3600*24*7)) -gt "$pacdate"
	then
	    echo "/!\\ pacman repos haven't been synced in over a week"
	    echo "/!\\ (since $(date -d "@$pacdate"))"
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
	if test -f /etc/apt/apt.conf
	then
		printf '\033[7mapt.conf\033[m\t%s\n' \
			"$(grep --color=never '^Acquire::http::Proxy' /etc/apt/apt.conf)"
	fi
}

proxy () {
	if ((# < 1))
	then
		print_proxy
		return
	fi
	case $1 in
		_on )
			if ((# != 2))
			then
				echo proxy _on requires a url
				return -1
			fi
			export http_proxy=$2
			export HTTP_PROXY=$http_proxy
			export https_proxy=$http_proxy
			export HTTPS_PROXY=$http_proxy
			export no_proxy=frbc.bull.fr,ao-srv.com
			export NO_PROXY=$no_proxy
			git config --global http.proxy "$http_proxy"
			if test -f /etc/apt/apt.conf
			then
				grep '^Acquire::http::Proxy' /etc/apt/apt.conf > /dev/null \
					|| echo "Acquire::http::Proxy \"$http_proxy\";" \
						| sudo tee -a /etc/apt/apt.conf > /dev/null
			fi
			print_proxy
			;;
		w3p2 | on )
			proxy _on http://w3p2.atos-infogerance.fr:8080
			;;
		w3p1 )
			proxy _on http://w3p1.atos-infogerance.fr:8080
			;;
		glb )
			proxy _on http://proxy-fr.glb.my-it-solutions.net:84
			;;
		off )
			export http_proxy=
			export HTTP_PROXY=$http_proxy
			export https_proxy=$http_proxy
			export HTTPS_PROXY=$http_proxy
			export no_proxy=
			export NO_PROXY=$no_proxy
			git config --global --unset http.proxy
			if test -f /etc/apt/apt.conf
			then
				grep '^Acquire::http::Proxy' /etc/apt/apt.conf > /dev/null \
					&& sudo sed -i '/^Acquire::http::Proxy/d' /etc/apt/apt.conf
			fi
			print_proxy
			;;
		* )
			echo "invalid command"
			;;
	esac
}

vpnc-connect () {
	sudo vpnc /etc/vpnc/bull.conf
}

vpnc-disconnect () {
	sudo vpnc-disconnect
	sudo ip route del 129.184.48.140
	sudo systemctl restart NetworkManager.service
}

gus () {
	git status "$@"
}

tiga () {
	tig --all "$@"
}

beep () {
	mplayer ~/.local/share/atone.mp3 &> /dev/null
}

# fmpoc/rttk stuff
export MODE=release
export ZLIB=yes

if test -d /usr/share/fzf
then
	. /usr/share/fzf/key-bindings.zsh
	. /usr/share/fzf/completion.zsh
elif test -d /usr/share/doc/fzf
then
	. /usr/share/doc/fzf/examples/key-bindings.zsh
	. /usr/share/doc/fzf/examples/completion.zsh
fi

if fd --version &> /dev/null
then
	export FZF_DEFAULT_COMMAND='fd --type f'
elif fdfind --version &> /dev/null
then
	export FZF_DEFAULT_COMMAND='fdfind --type f'
fi
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND

. $HOME/afm/devenv/devenv.sh

ado () {
	git -C $HOME/afm submodule foreach "$* ||:"
}

pair () {
	name=pair
	trap "rm /tmp/$name" INT TERM QUIT EXIT
	tmux -S /tmp/$name new -s $name -d
	chmod 777 /tmp/$name
	addr=$(ip a | grep -A2 tun0 | grep -o '[0-9.]\{11,15\}')
	cmd=$(printf 'test -e /tmp/%s && tmux -S /tmp/%s attach' $name $name)
	printf 'ssh -t guest@%s "%s"' "$addr" "$cmd" \
		| xclip -selection clipboard -i
	tmux -S /tmp/$name attach -t $name
}

bibgrep () {
	cd "$HOME/thesis/Biblio/pdf"
	for pdf in *.pdf
	do
		printf '\033[7m%s\033[m\n' "$pdf"
		pdftotext "$pdf" - | grep "$@"
	done
	cd -
}

if test -f /usr/bin/pass && test "$((RANDOM%6))" -eq 0
then
	printf '\033[7m%s\033[m\n' "checking password-store state…"
	pass git fetch syno \
		&& pass git status
fi

sshtee () {
	remote=${1:-vix}
	ssh "$remote" | tee --append "sessions_${remote}_$(date -Ihours).log"
}
