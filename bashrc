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

ggexcept() {
	git grep -i $1 -- ":(exclude)*/zxcvbn.js" ":(exclude)*/$2"
}

if [ -f ~/config/bashcolors ]; then
	. ~/config/bashcolors
fi

encoding_test="🤔" #if we see the character correctly, we are in an UTF-8 term

# Define basic PS1 with coloring: [User ~/Folder]
PS1="[$encoding_test$Red|$Color_Off$Green\u$Color_Off@$Cyan\h$Color_Off $Blue\w$Color_Off]"
# Define git stuff, if is in a git folder, it shows the name of the branch.
# And color it yellow when have no changes, and red if there is.
PS1=$PS1'$(git branch &>/dev/null;\
if [ $? -eq 0 ]; then \
  echo "$(echo `git status` | grep "nothing to commit" > /dev/null 2>&1; \
  if [ "$?" -eq "0" ]; then \
    # @4 - Clean repository - nothing to commit
    echo "'$Yellow'"$(__git_ps1 " (%s)"); \
  else \
    # @5 - Changes to working tree
    echo "'$IRed'"$(__git_ps1 " (%s)"); \
  fi)"; \
fi)'
export PS1=$PS1$Color_Off' \$ ';

# git aliases and functions
alias pega="git fetch origin; git pull --rebase origin \$(parse_git_branch)"
alias manda="git push origin \$(parse_git_branch)"
alias desfaztudo="git reset --hard origin/\$(parse_git_branch)"
function apagabranch() {
	git push origin :$1
	git branch -D $1
	echo git branch -D $1
}

function gem_install_puma() {
	gem install puma -v $1 -- --with-cppflags=-I/usr/include/openssl-1.0/
}

alias tmux="TERM=xterm-256color tmux"
