

#printf("Hello world");

# echo "Hello World"

# x=5
# echo $x

# foo=10
# echo "$foo"

# echo "Enter a number : "
# read number
# echo "Your number is : $number"

#if(number == 10); printf("Lucky!!!!")


# if [[ $number -eq 10 ]]; then
#     echo "You are lucky winner !!!"
# fi 


# if ((number == 10)); then 
#     echo "You are a lucky winner -C"
# fi 

# for ((i=0; i<number; i++)){
#     echo $i
# }

mkdir -p image
for filename in $(ls source)
do
    id="${filename::-4}"
    mkdir -p "image/$id"
    #cp source destination
    cp "source/$filename" "image/$id"
done




