# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
	*i*) ;;
	*) return;;
esac

export prt_Green="\e[1;32m"
export prt_Yellow="\e[1;33m"
export prt_Red="\e[1;31m"
export prt_RedLine="\e[4;31m"
export prt_GreenLine="\e[4;32m"
export prt_YellowLine="\e[4;33m"
export prt_End="\e[0m"

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
	xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
	if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
		# We have color support; assume it's compliant with Ecma-48
		# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
		# a case would tend to support setf rather than setaf.)
		color_prompt=yes
	else
		color_prompt=
	fi
fi

if [ "$color_prompt" = yes ]; then
	PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
	PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
	xterm*|rxvt*)
		PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
		;;
	*)
		;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=auto'
	#alias dir='dir --color=auto'
	#alias vdir='vdir --color=auto'

	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
if command -v exa > /dev/null; then
	alias el="exa -aHlFg --time-style=long-iso"
fi
alias ll="ls -alhF --time-style='+%Y/%m/%d_%H:%M:%S'"
alias la='ls -A'
alias l='ls -CF'
alias vi='vim'
alias clc='clear'

# if is WSL, add some WSL-unique-alias
uname -a | grep "Microsoft" >/dev/null
if [ $? -eq 0 ] ;then
	alias e.='explorer.exe .'
# 挂载网络磁盘
#	sudo mount -t drvfs D: /mnt/d
fi

# add android-termux command;
if [ -f ~/termux_sh.sh ]; then
	. ~/termux_sh.sh
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi


#导入 chrome 浏览器路径
export PATH=$PATH:/opt/google/chrome

#取消windows路径中的文件夹背景色
if [ -f ~/.dir_colors ]; then
	eval `dircolors $HOME/.dir_colors`
fi

#autojump
if [ -d $HOME/.autojump ]; then
	[[ -s $HOME/.autojump/etc/profile.d/autojump.sh ]] && source $HOME/.autojump/etc/profile.d/autojump.sh
fi

# 函数: 使用命令得到 git 项目的分支名字;
function parse_git_branch_and_add_brackets {
	git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\ \[\1\]/'
}
#设置ssh连接时的shell配色方案为 ubuntu 自带(加入了显示 git 分支的功能;)
#PS1="\h:\W \u\[\033[0;32m\]\$(parse_git_branch_and_add_brackets) \[\033[0m\]\$ "
#PS1="${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\$(parse_git_branch_and_add_brackets) \[\033[0m\]\$ "
PS1="${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[0;32m\]\$(parse_git_branch_and_add_brackets)\[\033[0m\]\$ "


# 自动挂载网络磁盘
#if [ ! -f "/mnt/u/.bashrc" ]; then
#	echo passwd | sudo -S mount -t drvfs U: /mnt/u
#	echo -e $prt_Green "mount netdisk U success!" $prt_End
#fi
