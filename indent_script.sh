#!/bin/bash

indent_size=4
level=0

sed 's/></>\n</g' "$1" | while read -r line; do
	line=$(echo "$line" | xargs)
	[[ -z "$line" ]] && continue

	if [[ "$line" =~ ^\<\/ ]]; then
		((level--))
	fi
	indent=""
	for ((i=0; i<level*indent_size; i++)); do
		indent+=" "
	done
	echo "${indent}${line}"
	if [[ "$line" =~ ^\<[^\/].*[^\/]\>$ ]]; then
		((level++))
	fi
done
