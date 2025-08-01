csv_line="Stdent ID"
while read -r line;
do
csv_line+=",$line"
done < "course.txt"

csv_line+="Total Marks,"
csv_line+="Average Marks,"
csv_line+="Grade"
echo "$csv_line">"a.csv"

declare -A arr

while read -r crs;
do
sort $crs.txt -o "$crs"_copy.txt
while read -r line;
do
# echo "$line"
roll="${line%%' '*}"
arr[$roll]=0
done < "$crs"_copy.txt 

done < "course.txt"



while read -r crs;
do
while read -r line;
do
# echo "$line"
roll="${line%%' '*}"
# echo $roll
mark="${line##*' '}"
# echo $mark
arr[$roll]=$(( $mark + ${arr[$roll]} ))
done < "$crs"_copy.txt
done < "course.txt"



for key in $(printf "%s\n" "${!arr[@]}" | sort);
do

avg=$(( ${arr[$key]} / 3 ))
grd=""
case $avg in
8[0-9]|9[0-9]|100)
grd="A"
;;
6[0-9]|7[0-9])
grd="B"
;;
4[0-9]|5[0-9])
grd="C"
;;
*)
grd="F"
;;
esac

csv_line="$key,"
while read -r crs;
do
line=$(grep "$key" "$crs"_copy.txt)
mark="${line##*' '}"
csv_line+="$mark,"
done < "course.txt"
csv_line+="${arr[$key]},"
csv_line+="$avg,"
csv_line+="$grd"
echo "$csv_line" >> "a.csv"
echo "$csv_line"
done


