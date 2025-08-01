#!/bin/bash
mediadir=$1
normalize_key() {
    local input="$1"
    input="${input,,}"         # Convert to lowercase
    input="${input// /}"       # Remove all spaces (or use _ instead)
    input="${input##*( )}"     # Trim leading spaces
    input="${input%%*( )}"     # Trim trailing spaces
    echo "$input"
}



declare -A titles
declare -A a
for file in "$mediadir"*;
do
filename="${file##*/}"

if [[ "$filename" =~ .- ]];
then
first_part="${filename%%-' '*}"
second_part="${filename##*-' '}"
second_part="${second_part%.*}" 

if [[ "$first_part" =~ \(.*\) ]]; then
    t="${first_part%(*}"
    second_part1="$second_part"
    second_part=$(normalize_key "$second_part")
    a["$second_part"]="$second_part1"
    titles["$second_part"]+="$t,"


else
    first_part1="$first_part"
    first_part=$(normalize_key "$first_part")
    a["$first_part"]="$first_part1"
    titles["$first_part"]+="$second_part,"   

fi

else
first_part="Unknown"
second_part="Unknown"

fi
done

echo "============================================================================"
> a.txt

for artist in $(printf "%s\n" "${!titles[@]}" | sort); do
    titl="${titles[$artist]%,}"
    art="${a[$artist]}"
    echo "$art: $titl"
    echo "$art" >> a.txt
    words=$(echo "$titl" | tr ',' '\n' | sort)
    while IFS= read -r w; do
        [[ -z "$w" ]] && continue
        echo "    $w" >> a.txt
    done <<< "$words"
done

