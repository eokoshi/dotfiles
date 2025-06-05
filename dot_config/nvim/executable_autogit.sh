#! /bin/bash

NO_CONFIRM=false
if [[ "$1" == "-y" ]]; then
  NO_CONFIRM=true
fi


diff_output=$(git diff --staged)
echo
if [ -z "${diff_output}" ]; then
	if $NO_CONFIRM; then
		git add *
	else
		read -p "No files staged. Add all and proceed? [y/n] " -n 1 -r
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			git add *
		else
			exit 1
		fi
	fi
fi

diff_output=$(git diff --staged)
prompt="\no-think [DIFF]: $diff_output \n\no-think [INSTRUCTIONS] Write a git commit message for this diff output in the form of a bulleted list, describing the changes to each individual file. Do not include ANY formatting e.g. bold text (**)."
response=$(echo "$prompt" | ollama.exe run qwen3)
message=$(echo "$response" | sed -e '/<think>/d' -e '/<\/think>/d' -e "/^$/d")

git status
echo "Commit message:"
echo "$message"
echo

if $NO_CONFIRM; then
	echo "$message" | git commit -qF -
	git push
else
	read -p "Proceed with commit? [y/n] " -n 1 -r
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		echo "$message" | git commit -qF -
		git push
	else
		git reset HEAD -- .
	fi
fi
