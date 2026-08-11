#!/usr/bin/env bash

# MKPS1
# (Mike Kasberg PS1)
# (Or, Make PS1)

# Different functions generate different parts (segments) of the PS1 prompt.
# Each function should leave the colors in a clean state (e.g. call RESET if they changed any colors).

RESET='\[\e[00m\]'

__chroot() {
	# This string is intentionally single-quoted:
	# It will be evaluated when $PS1 is evaluated to generate the prompt each time.
	if [[ "$(lsb_release -is 2>/dev/null)" == "Ubuntu" ]]; then
		echo '${debian_chroot:+[$debian_chroot]} '
	fi
}

__exitcode() {
	local code="${LAST_EXIT:-0}"
	local lsep=$'\ue0b2'
	local rsep=$'\ue0b0'
	local fg=7
	local bg=1
	local textcolor="\[\e[0;38;5;${fg};48;5;${bg}m\]"
	local sepcolor="\[\e[38;5;${bg}m\]"

	if [[ $code -ne 0 ]]; then
		echo "  $sepcolor$lsep$textcolor $code $RESET$sepcolor$rsep  "
	fi
}

__time() {
	local l_arrow=""
	local r_arrow=""
	local bg=""
	local sepcolor="\[\e[38;5;${bg}m\]"
	# local textcolor="\[\e[0;38;5;242;48;5;${bg}m\]"
	local textcolor="\[\e[0;38;5;242m\]"

	echo " $sepcolor$l_arrow$textcolor\t$RESET$sepcolor$r_arrow$RESET "
}

__hostname() {
	local textcolor
	case $(hostname) in
	eeftop) textcolor='\[\e[3;38;5;14m\]' ;;
	office) textcolor='\[\e[3;38;5;10m\]' ;;
	DF1) textcolor='\[\e[3;38;5;214m\]' ;;
	DF2) textcolor='\[\e[3;38;5;1m\]' ;;
	blue-starfish) textcolor='\[\e[3;38;5;123m\]' ;;
	halo) textcolor='\[\e[3;38;5;211m\]' ;;
	eefix) textcolor='\[\e[3;38;5;99m\]' ;;
	eefplex7050) textcolor='\[\e[3;38;5;184m\]' ;;
	MANAS-HP) textcolor='\[\e[3;38;5;9m\]' ;;
	lab-optiplex7050) textcolor='\[\e[3;38;5;120m\]' ;;
	*) textcolor='\[\e[3;38;5;38m\]' ;;
	esac

	echo "$textcolor\h$RESET "
}

__workdir() {
	local lsep=$'\ue0ba'
	local rsep=$'\ue0b0'
	local diricon=''
	local fg=7
	local bg=4
	local textcolor="\[\e[0;38;5;${fg};48;5;${bg}m\]"
	local sepcolor="\[\e[38;5;${bg}m\]"
	local sepcolor2="\[\e[38;5;${bg};48;5;235m\]"
	local textcolor2="\[\e[0;38;5;69m\]"

	# use top one for the powerline style, bottom one for simple colored text
	# echo "$sepcolor$lsep$textcolor \w $RESET$sepcolor2$rsep"
	echo "$textcolor2$diricon \w$RESET "
}

# For Git PS1
if [[ -f /usr/lib/git-core/git-sh-prompt ]]; then
	source /usr/lib/git-core/git-sh-prompt
elif [[ -f /usr/share/bash-completion/completions/git-prompt.sh ]]; then
	source /usr/share/bash-completion/completions/git-prompt.sh
fi
# GIT_PS1_SHOWDIRTYSTATE=0
# GIT_PS1_SHOWUPSTREAM="auto"

__git() {
	local lsep=$'\ue0b6'
	local rsep=$'\ue0b4'
	local gitbranch=$'\ue0a0'
	local fg=248
	local bg=""
	# local textcolor="\[\e[0;38;5;${fg};48;5;${bg}m\]"
	local textcolor="\[\e[0;38;5;242m\]"
	local sepcolor="\[\e[38;05;${bg}m\]"

	# Escaping the $ is intentional:
	# This is evaluated when the prompt is generated.
	# echo "\$(__git_ps1 '$textcolor $gitbranch %s ')$reset$sepcolor$rsep$reset";
	echo "\$(__git_ps1 '$textcolor$gitbranch %s') $RESET"

}

__venv_get() {
	local python='󰌠'
	local lsep=""
	local rsep=""
	local fg=178
	local bg=""
	# local textcolor="\[\e[0;38;5;${fg};48;5;${bg}m\]"
	local textcolor="\[\e[0;38;5;${fg}m\]"
	local sepcolor="\[\e[38;05;${bg}m\]"

	[ -n "$VIRTUAL_ENV" ] && echo " $sepcolor$lsep$textcolor$python$RESET$sepcolor$rsep$RESET "
}

__venv() {
	echo "\$(__venv_get)"
}

__box_top() {
	local color='\[\e[38;5;242m\]'
	local curve='╭╴'
	local box='┌╴'
	local box_heavy='┏╸'
	local double='╔═ '
	local curlybracket='⎧ '

	echo "$color$curve$reset"
}

__box_bottom() {
	local color='\[\e[0;38;5;242m\]'
	local curve='╰╴'
	local box='└╴'
	local box_heavy='┗╸'
	local double='╚═ '
	local curlybracket='⎩ '

	echo "$color$curve$reset"
}

__user_prompt() {
	local tall_chevron=$'\u3009'
	local small_chevron=$'\ueab6 '
	local box_icon=''
	local textcolor='\[\e[1;38;5;13m\]'
	local input='\[\e[0;97m\]'

	echo "$textcolor$box_icon$RESET "
}

check_chezmoi_nvim() {
	local color='\[\e[0;38;5;9m\]'
	local icon=''

	if ! chdiffnvim >/dev/null 2>&0; then
		echo "$color$icon$RESET"
	fi
}

__mkps1() {
	local ps1="
$(__box_top)$(__hostname)$(__chroot)$(__workdir)$(__git)$(__venv)$(__exitcode)$(check_chezmoi_nvim)$(__time)
$(__box_bottom)$(__user_prompt)"
	echo "$ps1"
}
