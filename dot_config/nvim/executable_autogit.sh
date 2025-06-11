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
			exit 0
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

# #!/bin/bash
#
# # Get the diff output
# DIFF_OUTPUT=$(git diff --staged)
#
# # Check if there is anything to commit
# if [ -z "$DIFF_OUTPUT" ]; then
#     echo "No changes staged for commit."
#     exit 0
# fi
#
# # Create JSON payload using jq to properly escape everything
# PAYLOAD=$(jq -n --arg diff "$DIFF_OUTPUT" '{
# 	"model": "deepseek-r1",
# 	"prompt": ($diff + "\n Write a git commit message for this diff output in the form of a bulleted list, describing the changes to each individual file. Do not include ANY formatting e.g. bold text (**)")
# 	"stream":false,
# 	"options": {
#
# 		num_ctx: 8096,
# 	},
# }')
#
# # Send the payload to OpenAI and capture the response
# RESPONSE=$(curl -x POST http://100.113.130.46:11434/api/chat \
#   -H "Content-Type: application/json" \
#   -d "$PAYLOAD" )
#
# # Extract the summary from the response
# SUMMARY=$(echo "$RESPONSE" | jq -r '.choices[0].message.content')
#
# # Check for errors in the API response
# if [ -z "$SUMMARY" ]; then
#     echo "Failed to get a summary from LLM."
#     exit 1
# fi
#
# # Output the summary
# echo "Change summary:"
# echo "$SUMMARY"
# echo ""
#
# # Ask the user if they want to commit
# read -p "Do you want to commit these changes? (yes/no): " USER_INPUT
#
# # Check if the user's input is "yes"
# if [ "$USER_INPUT" = "yes" ]; then
#     git commit -m "$SUMMARY"
#     echo ""
#     echo "Changes committed."
# else
#     echo "No commit made."
# fi
