declare -A places
while read -r line ;
do
echo $line
places["$line"]=0
done < "places.txt"

while read -r line ;
do
echo "$line"
    words=$(echo "$line" | tr ',' '\n')
    while IFS= read -r w; do
        [[ -z "$w" ]] && continue
        cnt=$(grep -c -iw "$w" "places.txt")
        if [[ $cnt -gt 0 ]];
        then
        places["$w"]=$(( "${places["$w"]}" + 1 ))
        fi
    done <<< "$words"
done < "visited.csv"
>a.txt
minkey=10000
minval=""
for key in "${!places[@]}";
do
echo "$key  ${places["$key"]}" >> a.txt
if [[ $minkey -gt ${places["$key"]} ]];
then
minkey=${places["$key"]}
minval="$key"
fi
done

echo "$minval"
