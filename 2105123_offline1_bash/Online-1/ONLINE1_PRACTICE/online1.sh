echo -n "Enter your name "
read name
echo "$name"

echo -n "Enter another name "
read name2
echo "$name2"

if [[ "$name" = "$name2" ]];
then
echo "name are equal"
elif [[ "$name" != "$name2"  ]];
then echo "name are not equal"
fi

read n
if [[ $n -gt 100 ]];
then
echo "$n is greater than 100"
elif [[ $n -gt 50 ]];
then echo "$n is greater than 50"
else
echo "$n is smaller"
fi

string1="i love cse buet"

if [[ -n "$string1" ]];
then
echo "$string1 is not null"
elif [[ -z "$string1" ]];
then
echo "$string1 is null"
fi

expression1=$(expr 10 + 4)
echo $expression1
expression2=$(expr 10 + 1)
echo $expression2

if [[ $expression1 -gt $expression2 ]];
then
echo "Greater"
elif [[ $expression1 -ge $expression2 ]];
then
echo "Greater equal"
elif [[ $expression1 -lt $expression2 ]];
then
echo "Less than"
elif [[ $expression1 -le $expression2 ]];
then
echo "Less equal"
fi

if [[ $expression1 != $expression2 ]];
then
echo "not equal"
fi

echo "Have you eaten?"
read ans
case $ans in
y*|Y*)echo "Good"
;;
n*|N*)echo "Please have these cookies"
;;
*)
echo "Can not understand"
;;
esac

echo $1
echo $*
echo $#

total=0
for((i=0;i<=5;i++));
do
total=$(($total + $i))
done

echo $total

total=0
for i in $*;
do
total=$(($total + $i))
echo $total
done

read password
count=1
while [[ $password != "hack" ]];
do
echo "$password is wrong"
read password
count=$(($count + 1))
done

echo "$password is matched in the $count th attempt"

take_sum()
{
    sum=0
    for i in $*;
    do
    # echo "$i"
    sum=$(($sum + $i))
    done
    echo $sum
}

result=$(take_sum 1 2 3 4)
echo $result

visit()
{
    if [[ -f "$1" ]];
    then
    echo "we have visited "$1""
    elif [[ -d "$1" ]];
    then
    for i in "$1"/*;
    do
    visit "$i"
    done
    fi
}
visit "practice online 1"

mkdir -pv blueberry raspberry
mkdir -pv shatabdi/buet/cse/cse301
mkdir -p krashna/cse/shatabdi/buet/cse314

echo hello>a.txt
cat a.txt
echo world>a.txt
cat a.txt

echo hwordfs>>a.txt
cat a.txt
echo wseqdwew>>a.txt
cat a.txt

cp -r krashna another
cp -r krashna raspberry

rm -ri raspberry
rm a.txt 2>>err.txt
{cat < 2.txt;} 2>>err.txt
cat err.txt
sort a.txt
uniq -c a.txt
echo 1,2,3,4,5,6,7,8,9,10>>b.txt

cat b.txt
sort -n b.txt
sort -nr b.txt
uniq -c b.txt

tr -c '[:alnum:]' '[\n*]' < a.txt | head -n 5
tr -c '[:alnum:]' '[\n*]' < a.txt | tr '[:upper:]' '[:lower:]'| sort  | uniq -c  | sort -nr
tr -c '[:alnum:]' '[\n*]' < a.txt | tr '[:upper:]' '[:lower:]'| sort  | uniq -c  | sort -nr | head -n 15

tail -F new.txt

linecount=$(cat a.txt | wc -l)
echo $linecount

wordcount=$(cat a.txt | wc -w)
echo $wordcount

cat b.txt | cut -d: -f1
grep -i "^one" a.txt
grep -iw "^one" a.txt
grep -iv "^one" a.txt

grep  -n -C 3 "^ahh" a.txt

ln -s ~/pwd ~/online1shortcut

ps aux
ps aux |grep root

sudo apt update
sudo apt autoremove

myArray=("cat" "dog" "mouse" "frog")
myArray[10]="far"

for str in ${myArray[@]};
do
echo $str
done

for i in ${!myArray[@]};
do
echo "element $i is ${myArray[$i]}"
done


mkdir -p image
for filename in $(ls source)
do
    id="${filename::-4}"
    mkdir -p "image/$id"
    #cp source destination
    cp "source/$filename" "image/$id"
done
'

: 'practice problem 1

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



practice problem 2
for folder in *; do
    echo "$folder"
    
    find "$folder" -type f -name "*.txt" | while IFS= read -r i; do
        echo "Reading file: $i"
        filebasename=${i##*/}
        echo "Base file name : $filebasename"
        if [[ ! -f "$i" ]]; then
            echo "File not found: $i"
            continue
        fi

        cnt=0
        country=""
        role=""
        change=false

        while IFS= read -r line; do 
            cnt=$((cnt + 1))


            if [[ $cnt -eq 2 ]]; then
                country="$line"
            fi
            if [[ $cnt -eq 4 ]]; then
                role="$line"
            fi

        done < "$i"

        echo "Total lines read: $cnt"
        echo "Country: $country"
        echo "Role: $role"
        if [[ ! -d "$country/$role" ]];
        then
        mkdir -p "$country/$role"
        change=true
        
        fi
        if [[ ! -e "$country/$role/$filebasename" ]];
        then
        cp  "$i" "$country/$role/$filebasename"
        fi
        if [[ $change == true ]];
        then
        rm -rf "$i"
        fi
    done
    
done

for remfolder in *;
do
if [[ -z "$(find "$remfolder" -type f)" ]]; then
    echo "$remfolder is completely empty"
    rm -rf "$remfolder"
else
    echo "$remfolder has files"
fi

done


practice problem 3
if [[ $# -lt 1 ]]
then
kill $$ INT
fi
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

    fi
}
for k in *;
do
visit "$k"
done
sort -n $tempFile  > sorted.txt
rm -rf $tempFile
cnt=1
while IFS= read -r line;
do
echo $line
filesize=${line%%:*}
echo $filesize
filepath=${line#*:}
echo $filepath
if [[ ! -e "$dest_dir/$cnt.pdf" ]];
then
cp "$filepath" "$dest_dir/$cnt.pdf"
cnt=$(( $cnt + 1 ))
fi
done < sorted.txt
rm -rf sorted.txt





fact() {
    if [[ $1 -eq 0 ]]; then
        echo 1
        return
    fi
    last=$(fact $(($1 - 1)))
    echo $(($1 * $last))
}
fact 5


fibonacci() {
    if [[ $1 -le 1 ]]; then
        echo $1
    else
        a=$(fibonacci $(($1 - 1)))
        b=$(fibonacci $(($1 - 2)))
        echo $(($a + $b))
    fi
}
fibonacci 7



I/O redirections
ls /nonexistent &> out.txt
ls /nonexistent > out.txt 2>&1




[[ $# -ne 1 ]] && exit 1
pat=$1
# while read line; do
while read line;
do
    if echo "$line" | grep -q "$1"; then
        echo "$line"
    fi
    if grep -q "cin" <(echo "$line"); then
        echo "$line"
    fi
done




cut -d: -f1 out.txt 
find * -type f -exec tar -rvf backup.tar {} \;
find . -type f -name "*.sh" | wc -l
find . -type f -name "*.txt" | xargs rm