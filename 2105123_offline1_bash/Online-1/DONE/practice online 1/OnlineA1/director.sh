for filename in "movie_data/"*.txt
do
fileBaseName="${filename##*/}"  
echo $filename
found_blank=false
count=0
directorname=""
# grep -n '^$' "$filename"
while IFS= read -r line ;
do
if [[ -z "$line" ]];then
((count++))
echo $count

elif [[ $count -eq 2 ]];
then
directorname="$line"
break
fi
done <"$filename"
echo $directorname
if [[ ! -d "movie_data/$directorname" ]];
then
mkdir -p "movie_data/$directorname" 
fi
if [[ ! -e "movie_data/$directorname/$fileBaseName" ]];
then
cp "$filename" "movie_data/$directorname/$fileBaseName"
fi


done

for filename in "movie_data/"*.txt
do
rm -rf "$filename"
done