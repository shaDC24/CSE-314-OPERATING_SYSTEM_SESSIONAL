#!/bin/bash
cntm=0
cnta=0
cnte=0

mkdir -p "ok/morning"
mkdir -p "ok/afternoon"
mkdir -p "ok/evening"
for files in "photos_input/"*.jpg;
do

filename1="${files##*/}"
filename="${filename1%.jpg}"
t="${filename: (-6) : 6}"
x="${t: (0) : 2}"
echo $x
case $x in
0[0-9]|1[0-1])
if [[ -f "$files" ]];
then
mv "$files" "ok/morning/morning_$filename1"
cntm=$(( $cntm + 1))
fi
;;

1[2-7])
if [[ -f "$files" ]];
then
mv "$files" "ok/afternoon/afternoon_$filename1"
cnta=$(( $cnta + 1))
fi
;;
1[8-9]|2[0-3])
if [[ -f "$files" ]];
then
mv "$files" "ok/evening/evening_$filename1"
cnte=$(( $cnte + 1))
fi
;;
esac
done

> "ok/a.txt"

echo "morning $cntm " >> "ok/a.txt"
echo "afternoon $cnta " >> "ok/a.txt"
echo "evening $cnte " >> "ok/a.txt"
