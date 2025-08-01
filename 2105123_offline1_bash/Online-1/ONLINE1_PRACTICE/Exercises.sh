#!/bin/bash

# Create 4 files named project_<your_id>.java, 
# project_<your_id>.js, project_<your_id>.html, and 
# project_<your_id>.css. 
# ● Then, create a directory called web_project. Inside 
# web_project, create subdirectories named backend, 
# frontend, and styles. Move the .java file to backend, the 
# .js and .html files to frontend, and the .css file to 
# styles


files=("project_1.java" "project_1.js" "project_1.html" "project_1.css")


for file in ${files[@]};
do
touch $file
done 

mkdir -p web_project
subdir=("backend" "frontend" "styles")

for i in ${subdir[@]};
do
  mkdir -p "web_project/$i"
done

for file in $(ls);
do
extns="${file##*.}"  
case $extns in
java)
mv $file "web_project/backend"
;;
js)
mv $file "web_project/frontend"
;;
html)
mv $file "web_project/frontend"
;;
css)
mv $file "web_project/styles"
;;
esac
done 

# ●
# Create 4 files named old_report.docx, draft.docx,
# old_photo.png, and snapshot.png. Create two directories named
# documents and images.
# ○Rename draft.docx to final_report.docx.
# ○Move all .docx files to the documents directory.
# ○Move all .png files to the images directory.
# ○List the contents of both documents and images directories.
# ○Now move all files beginning with old to a new directory named
# archived


files=("old_report.docx" "draft.docx" "old_photo.png" "snapshot.png")

for i in ${files[@]};
do
touch $i
done

mv "draft.docx" "final_report.docx"
mkdir -p documents
mkdir -p images
for file in *;
do
extns=${file##*.}
case $extns in
docx)
mv $file documents
;;
png)
mv $file images
;;
esac
done

