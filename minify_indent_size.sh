#!/bin/bash

minify_html() {
    local file=$1
    sed -e 's///g' "$file" | tr -d '\n' | sed 's/>[[:space:]]\+</></g'
}

pretty_print_custom() {
    local file=$1
    local indent_size=$2
    local level=0

    sed 's/></>\n</g' "$file" | while read -r line; do
        line=$(echo "$line" | xargs)
        [[ -z "$line" ]] && continue

        [[ "$line" =~ ^\<\/ ]] && ((level--))

        indent=""
        for ((i=0; i<level*indent_size; i++)); do
            indent+=" "
        done

        echo "${indent}${line}"

        if [[ "$line" =~ ^\<[^\/].*\>$ ]] && [[ ! "$line" =~ \/\>$ ]] && [[ ! "$line" =~ ^\<\/ ]]; then
             [[ ! "$line" =~ .*\<\/.* ]] && ((level++))
        fi
    done
}

case "$1" in
    --minify)
        minify_html "$2"
        ;;
    --indent)
        pretty_print_custom "$3" "$2"
        ;;
    *)
        echo "Utilizare:"
        echo "  $0 --minify fisier.html"
        echo "  $0 --indent [size] fisier.html"
        ;;
esac
