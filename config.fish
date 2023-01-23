if status is-interactive
	# Commands to run in interactive sessions can go here
end
set DEFAULT_USER renatolond

function prompt_status
	set -l CROSS (printf "\u2718")
	set -l LIGHTNING (printf "\u26a1")
	set -l GEAR (printf "\u2699")
	set -l my_symbols ""
	# Was last command successful?
	if test $status -ne 0
		set my_symbols "$my_symbols"(set_color red)"$CROSS"
	end
	set -l user_id $(id -u)
	# Is user root?
	if test $user_id -eq 0
		set my_symbols "$my_symbols"(set_color yellow)"$LIGHTNING"
	end
	set -l job_count (jobs -l | wc -l)
	if test $job_count -gt 0
		set my_symbols "$my_symbols"(set_color cyan)"$GEAR"
	end

	if test -n "$my_symbols"
		echo -en "$my_symbols"(set_color red)"|"(set_color normal)
	end
end

function fish_greeting
end

function prompt_context
	set -l user $(whoami)

	if test $user != $DEFAULT_USER
		echo -en (set_color green)"$user\e[49m"
		if test -n "$SSH_CONNECTION"
			echo -en "@"(set_color cyan)"$hostname\e[49m"
		end
	end
end

function fish_prompt
	set -lx fish_prompt_pwd_dir_length 0
	set -lx __fish_git_prompt_show_informative_status 1
	set -lx __fish_git_prompt_showuntrackedfiles 1
	set -lx __fish_git_prompt_showdirtystate 1
	set -lx __fish_git_prompt_showstashstate 1
	set -lx __fish_git_prompt_showupstream auto
	set -lx __fish_git_prompt_color_prefix normal
	set -lx __fish_git_prompt_color_suffix normal
	set -lx __fish_git_prompt_color yellow
	set -lx __fish_git_prompt_color_stashstate --bold brblue
	set -lx __fish_git_prompt_color_dirtystate blue
	set -lx __fish_git_prompt_color_untrackedfiles brwhite
	set -lx __fish_git_prompt_color_stagedstate red
	set -lx __fish_git_prompt_color_invalidstate red
	set -lx __fish_git_prompt_color_upstream brwhite
	set -lx __fish_git_prompt_color_cleanstate green
	set -lx __fish_git_prompt_char_upstream_ahead ⇡
	set -l encoding_test "🧟" #if we see the character correctly, we are in an UTF-8 term

	echo -n "["(set_color red)"$encoding_test|"(set_color normal)
	prompt_status
	prompt_context
	echo -n " "(set_color blue)(prompt_pwd)(set_color normal)"]"
	spaceship_ruby
	fish_git_prompt
	echo -n (set_color magenta)"❯ "(set_color normal)
end
function fish_right_prompt
	echo -n (set_color yellow)"["(date '+%H:%M:%S')"]"(set_color normal)
end

# git branch
function parse_git_branch
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
end

alias pega="git fetch origin; git pull --rebase origin \$(parse_git_branch)"
alias manda="git push origin \$(parse_git_branch)"
alias mandacomforca="git push origin --force-with-lease \$(parse_git_branch)"
alias desfaztudo="git reset --hard origin/\$(parse_git_branch)"
alias pegalogo="git stash -u && pega && git stash pop"
alias stashgeral="git add . && git stash"
alias tempoembxl="curl 'https://wttr.in/brussels?format=4'"


if test -f .ruby-version
	rvm use
else
	rvm default
end
