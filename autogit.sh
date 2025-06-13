#!/bin/bash

NO_CONFIRM=false
if [[ "$1" == "-y" ]]; then
  NO_CONFIRM=true
fi


DIFF_OUTPUT=$(git diff --staged)
echo
if [ -z "${DIFF_OUTPUT}" ]; then
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
DIFF_OUTPUT=$(git diff --staged)

# Create JSON payload using jq to properly escape everything
PROMPT="$DIFF_OUTPUT Write a git commit message for this diff output in the form of a bulleted list, with one line per file (summarize changes in one line). DO NOT USE MARKDOWN FORMATTING, DO NOT USE ASTERISKS * OR BACKTICKS. BEGIN EACH NEWLINE WITH - /no_think"
PAYLOAD=$(jq -n --arg prompt "$PROMPT" '{
	"model": "qwen3:latest",
	"messages": [{"role":"system","content":"DO NOT USE MARKDOWN FORMATTING (NO backticks ` or asterisks *)"},{ "role": "user", "content": $prompt }],
	"stream": false,
	"params": { 
		"num_ctx": 131072
	}
}')

# Send the payload to OpenAI and capture the response
RESPONSE=$(curl -X POST http://100.113.130.46:11434/api/chat \
  -H "Content-Type: application/json" \
  -d "$PAYLOAD" )

# Extract the summary from the response
MESSAGE=$(echo "$RESPONSE" | jq -r '.message.content' | sed -e '/<think>/d' -e '/<\/think>/d' -e "/^$/d")

# Check for errors in the API response
if [ -z "$MESSAGE" ]; then
    echo "Failed to get a summary from LLM."
    exit 1
fi

# Output the summary
echo "Commit message:"
echo "$MESSAGE"
echo ""

if $NO_CONFIRM; then
	echo "$MESSAGE" | git commit -qF -
	git push
else
	read -p "Proceed with commit? [y/n] " -n 1 -r
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		echo "$MESSAGE" | git commit -qF -
		git push
	else
		git reset HEAD -- .
	fi
fi
