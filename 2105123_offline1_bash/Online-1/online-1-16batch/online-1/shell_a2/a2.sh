if [[ $# -lt 1 ]]
then
kill $$ INT
fi
new_dir=new
mkdir -p $new_dir
dest_dir=2105123
tempFile=filetoremove.txt
min_page_number=$1
if [[ ! -d "$dest_dir" ]];
then
mkdir "$dest_dir"
fi
touch "$tempFile"
visit()
{
    if [[ -f "$1" && "$1" == *.pdf ]];
    then
    nextToDo "$1"
    elif [[ -d "$1" ]];
    then
     for i in "$1"/*;
     do
        visit "$i"
     done

    fi
}
nextToDo()
{
    file=$1
    # echo "$1 has come to next to do"
    pages=$(pdfinfo "$file" | grep ^Pages: | awk '{print $2}')
    if [[ $pages -gt $min_page_number ]];
    then
        size=$(stat -c%s "$file")
        size_hr=$(du -h "$file" | cut -f1)
        echo "$size:$file" >> $tempFile
        if [[ ! -e "$new_dir/${file##*/}" ]];
        then
        cp "$file" "$new_dir/${file##*/}"
        fi

    fi
}
for k in *;
do
visit "$k"
done
cnt=1

find "$new_dir" -type f -printf "%s %p\n" | sort -n | while read -r size file; do
    # Extract extension if needed, or just name them as .pdf
    mv "$file" "$new_dir/$cnt.pdf"
    cnt=$((cnt + 1))
done
ls -la "$new_dir"
# sort -n $tempFile  > sorted.txt
# rm -rf $tempFile
# cnt=1
# while IFS= read -r line;
# do
# echo $line
# filesize=${line%%:*}
# echo $filesize
# filepath=${line#*:}
# echo $filepath
# if [[ ! -e "$dest_dir/$cnt.pdf" ]];
# then
# cp "$filepath" "$dest_dir/$cnt.pdf"
# cnt=$(( $cnt + 1 ))
# fi
# done < sorted.txt
# rm -rf sorted.txt
