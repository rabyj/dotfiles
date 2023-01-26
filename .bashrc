# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
export HISTCONTROL=ignoreboth:erasedups

HISTIGNORE="&:ls:ll:exit:pwd:clear:mount:umount:?:??:history"

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=1000000
export HISTFILESIZE=1000000000

# save the commands for every session into the same source
export PROMPT_COMMAND='history -a'

HISTTIMEFORMAT=''       # Save the timestamp, but don't output it
#HISTTIMEFORMAT='%F_%T ' # output the time in 'history' see "ht" alias

# History Aliases...
h()  { history 30; }                          # last few history commands
ht() { HISTTIMEFORMAT='%F_%T  ' history 30; } # history with time stamps

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
#force_color_prompt=yes

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
alias llt="ls -ahlFtr" #reverse time lookup (oldest last), w size prefixes
alias lla='ls -ahlF'
alias ll='ls -hlF'
alias la='ls -A'
alias l='ls -CF'

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

# Verification du mount du repertoire reseau personnel
#vdmdrrp8nov2012 (tag de validation)
MOUNT_COUNT=$(mount -v | egrep $USER/Lecteurs_Reseau/Personnel --count )
 if [ "$MOUNT_COUNT" = "0" ] ; then
	echo -e "\\033[1;31m" "ATTENTION: Erreur lors du montage de votre espace réseau \n\t\t\t \"Personnel\"  " " \\033[0;39m"
fi




# -- Convenience commands --
alias cp="cp -v --no-clobber"
alias mv="mv -v --no-clobber"

git-update() {
    git fetch && git status
}

alias htopme="htop -u rabj2301"
alias open="xdg-open"
eval "$(thefuck --alias)" #fuck

# automount narval
alias mount-narval="sshfs -o follow_symlinks rabyj@narval.computecanada.ca:/home/rabyj/ $HOME/Projects/narval-mount/"
alias mount-beluga="sshfs -o follow_symlinks rabyj@beluga.computecanada.ca:/home/rabyj/ $HOME/Projects/beluga-mount/"

# tried to use this but failed : https://stackoverflow.com/questions/43256369/how-to-rename-a-virtualenv-in-python/68400551#68400551
myroot="$HOME/Projects"
alias source-epilap=". ${myroot}/epilap/venv-epilap-pytorch/bin/activate" # for epilap local venv

# Add user pylint
# export PATH=$PATH:$HOME/.local/bin

# Change the depth of directory showed in terminal line
export PROMPT_DIRTRIM=2


# Function to allow a user to arbitrarily set the terminal title to anything
# Example: `set-title this is title 1`
set-title() {
    # Set the PS1 title escape sequence; see "Customizing the terminal window title" here:
    # https://wiki.archlinux.org/index.php/Bash/Prompt_customization#Customizing_the_terminal_window_title
    TITLE="\[\e]2;$@\a\]"
    PS1=${PS1_BAK}${TITLE}
}

# Back up original PS1 Prompt 1 string when ~/.bashrc is first sourced upon bash opening
if [[ -z "$PS1_BAK" ]]; then # If length of this str is zero (see `man test`)
    PS1_BAK=$PS1
fi

# Set the title to a user-specified value if and only if TITLE_DEFAULT has been previously set and
# exported by the user. This can be accomplished as follows:
#   export TITLE_DEFAULT="my title"
#   . ~/.bashrc
# Note that sourcing the ~/.bashrc file is done automatically by bash each time you open a new bash
# terminal, so long as it is an interactive (use `bash -i` if calling bash directly) type terminal
if [[ -n "$TITLE_DEFAULT" ]]; then # If length of this is NONzero (see `man test`)
    set-title "$TITLE_DEFAULT"
fi
