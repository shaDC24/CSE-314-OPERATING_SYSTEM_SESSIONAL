mkdir -p "output"
while read -r line;
do
mapfile -t a < <(find "classified_01" -type f)
for files in "${a[@]}";
do

cnt=$( grep -c -iw "$line" "$files")
if [[ $cnt -gt 0 ]];
then
mkdir -p "output/$line"
cp "$files" "output/$line/${files##*/}"
fi 
done

done < keywords.txt


