# Allow for commeting out CLI lines
setopt interactive_comments


# Include colors for 'ls'
alias ls='ls --color=auto'


# Always include mathlib (so you can floating point results etc..)
alias bc='bc --mathlib'


# Always use color for `grep`
alias grep='grep --color'


# Preferred options for History
export HISTSIZE=100000
export SAVEHIST=$HISTSIZE
setopt hist_ignore_all_dups
setopt hist_ignore_space     # precede line with a space to exclude it from history


# Make sure '/' is not counted as a word character
# doing this allows for ctrl+back-arrow to stop at forward-slashes
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'


# used in subsequent directives...
HOMEBREW_ROOT=/opt/homebrew


# Set PATH, MANPATH, etc., for Homebrew.
[ -x $HOMEBREW_ROOT/bin/brew ] \
    && eval "$($HOMEBREW_ROOT/bin/brew shellenv)"


# Add homebrew installed gnu utits to PATH
[ -d $HOMEBREW_ROOT/opt/make/libexec/gnubin ] \
    && PATH="$HOMEBREW_ROOT/opt/make/libexec/gnubin:$PATH"


# Pyenv
if [ -x $HOMEBREW_ROOT/bin/pyenv ]; then
    PYENV_ROOT=$HOMEBREW_ROOT/Cellar/pyenv
    eval "$($HOMEBREW_ROOT/bin/pyenv init -)"
fi


# Plenv
[ -x $HOMEBREW_ROOT/bin/plenv ] \
    && eval "$($HOMEBREW_ROOT/bin/plenv init - zsh)";


# if `bat` exists, set alias that includes wanted theme
type bat > /dev/null \
    && alias bat='bat --theme="Visual Studio Dark+"'


# Node Version Manager (NVM) -- it's slow, so require function call to use it
nvm_init() {
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
}


# ====== Google Cloud Shell Utilities ======

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/code/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/code/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/code/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/code/google-cloud-sdk/completion.zsh.inc"; fi

# ==========================================


# ====== Prompt customization ======

# Allow for expansion of variables in format strings and 'PROMPT'
setopt PROMPT_SUBST

# VCS (git) status
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr '%F{3}'
zstyle ':vcs_info:git:*' unstagedstr '%F{1}'
zstyle ':vcs_info:*' actionformats '%f(%F{2}%u%c%b%F{3}|%F{1}%a%f) '
zstyle ':vcs_info:*' formats '%f(%F{2}%u%c%b%f) '

# I don't like my work laptop hostname
[[ $HOST =~ MBPR$ ]] && HN="waptop" || HN=$HOST

# Prompt definition
PROMPT='[%F{4}%n@$HN%f] %~ $vcs_info_msg_0_%f%# '

# ==================================


# ====== Tab completion ======

## highlight the current autocomplete option
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

## better ssh/rsync/scp autocomplete
zstyle ':completion:*:(scp|rsync):*' tag-order ' hosts:-ipaddr:ip\ address hosts:-host:host files'
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'

## allow for autocomplete to be case insensitive
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' \
  '+l:|?=** r:|?=**'

## initialize the autocompletion
autoload -Uz compinit && compinit -i

# ============================
