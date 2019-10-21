# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME=""

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(nvm git-prompt zsh-autosuggestions)
# Zsh-autosuggestions need to be installed from https://github.com/zsh-users/zsh-autosuggestions

source $ZSH/oh-my-zsh.sh

# User configuration

# Lines added by compinstall
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' max-errors 2
zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=$HISTSIZE
setopt appendhistory autocd
setopt share_history
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
unsetopt beep
bindkey -v
bindkey '^R' history-incremental-search-backward
bindkey "^[OH" beginning-of-line
bindkey "^[OF" end-of-line
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
# End of lines configured by zsh-newuser-install
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line
export EDITOR=vim
export VISUAL=vim

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# git branch
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}
vimgitshow() {
  if [[ -z "$2" ]] ; then
    git show "$1" | vim - "+set filetype=${1##*.}";
  else
    git show $2:"$1" | vim - "+set filetype=${1##*.}";
  fi
}

alias pega="git fetch origin; git pull --rebase origin \$(parse_git_branch)"
alias manda="git push origin \$(parse_git_branch)"
alias mandacomforca="git push origin --force-with-lease \$(parse_git_branch)"
alias desfaztudo="git reset --hard origin/\$(parse_git_branch)"
alias pegalogo="git stash -u && pega && git stash pop"
alias stashgeral="git add . && git stash"
function gem_install_puma() {
    gem install puma -v $1 -- --with-cppflags=-I/usr/include/openssl-1.0/
}
alias tempoembxl="curl 'https://wttr.in/brussels?format=4'"

encoding_test="🧟" #if we see the character correctly, we are in an UTF-8 term

source "$HOME/config/ruby.zsh"

DEFAULT_USER=renatolond
CROSS="\u2718"
LIGHTNING="\u26a1"
GEAR="\u2699"

prompt_context() {
  local user=`whoami`

  if [[ "$user" != "$DEFAULT_USER" ]]; then
    if [[ -n "$SSH_CONNECTION" ]]; then
      print -n "%F{green}%n%f@%F{cyan}%m%f"
    else
      print -n "%F{green}%n%f"
    fi
  fi
}

prompt_status() {
  RETVAL=$?
  local symbols
  symbols=()
  [[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}$CROSS"
  [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}$LIGHTNING"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}$GEAR"

  [[ -n "$symbols" ]] && print -n "$symbols%F{red}|%f"
}

PROMPT='[%F{red}$encoding_test|%f$(prompt_status)$(prompt_context) %F{blue}%3~%f]$(spaceship_ruby) $(git_super_status)%F{magenta}❯%f '
RPROMPT=''

ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_SUFFIX=")"
ZSH_THEME_GIT_PROMPT_SEPARATOR="|"
ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[red]%}%{●%G%}"
ZSH_THEME_GIT_PROMPT_CONFLICTS="%{$fg[red]%}%{✖%G%}"
ZSH_THEME_GIT_PROMPT_CHANGED="%{$fg[blue]%}%{✚%G%}"
ZSH_THEME_GIT_PROMPT_BEHIND="%{⇣%G%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{⇡%G%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{…%G%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}%{✔%G%}"

eval $(thefuck --alias)
