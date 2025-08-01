!/bin/bash

if [[ -z "$string" ]]; then
  echo "String is empty"
elif [[ -n "$string" ]]; then
  echo "String is not empty"
fi

==============================================
set -euo pipefail
IFS=$'\n\t'
=================================================
echo {A,B}.js

{A,B} 	Same as A B
{A,B}.js 	Same as A.js B.js
{1..5} 	Same as 1 2 3 4 5
{{1..3},{7..9}} 	Same as 1 2 3 7 8 9
================================================
wildcard="*.txt"
options="iv"
cp -$options $wildcard /tmp
=================================================
name="John"
echo "${name}"
echo "${name/J/j}"    #=> "john" (substitution)
echo "${name:0:2}"    #=> "Jo" (slicing)
echo "${name::2}"     #=> "Jo" (slicing)
echo "${name::-1}"    #=> "Joh" (slicing)
echo "${name:(-1)}"   #=> "n" (slicing from right)
echo "${name:(-2):1}" #=> "h" (slicing from right)
echo "${name:(-4):4}" #=> "John"
echo "${food:-Cake}"  #=> $food or "Cake"
===============================================

Substrings
str="dwehcbehd"
echo ${str:0:2} 	#Substring (position, length)
echo ${str:(-3):3} 	#Substring from the right

===================================================
str="/path/to/foo.cpp"
echo "${str%.cpp}"    # /path/to/foo
echo "${str%.cpp}.o"  # /path/to/foo.o
echo "${str%/*}"      # /path/to

echo "${str##*.}"     # cpp (extension)
echo "${str##*/}"     # foo.cpp (basepath)

echo "${str#*/}"      # path/to/foo.cpp
echo "${str##*/}"     # foo.cpp

echo "${str/foo/bar}" # /path/to/bar.cpp
str="Hello world"
echo "${str:6:5}"    # "world"
echo "${str: -5:5}"  # "world"
src="/path/to/foo.cpp"
base=${src##*/}      #=> "foo.cpp" (basepath)
dir=${src%$base}     #=> "/path/to/" (dirpath)
================================================
name=joe
pointer=name
echo ${!pointer}
===================================================
Substitution

${foo%suffix} 	#Remove suffix
${foo#prefix} 	#Remove prefix
${foo%%suffix} 	#Remove long suffix
${foo/%suffix} 	#Remove long suffix
${foo##prefix} 	#Remove long prefix
${foo/#prefix} 	#Remove long prefix
${foo/from/to} 	#Replace first match
${foo//from/to} 	#Replace all
${foo/%from/to} 	#Replace suffix
${foo/#from/to} 	#Replace prefix
${#foo} 	#Length of $foo

foo="hello_world.txt"
bar="hello.world.txt"
file="report.final.draft.docx"
path="/home/shekhar/code/file.java"
greeting="hello_world"
filename="data.txt"
animal="cat_dog_cat"

echo "Original foo: $foo"
echo "1. Remove shortest suffix (.txt): ${foo%.txt}"      
echo "2. Remove shortest prefix (hello_): ${foo#hello_}"  
echo -e "\nOriginal bar: $bar"
echo "3. Remove longest suffix (.*): ${bar%%.*}"          
echo "5. Remove longest prefix (*.): ${bar##*.}"          
echo -e "\nOriginal file: $file"
echo "4. Remove suffix matching pattern: ${file/%.*}"     
echo -e "\nOriginal path: $path"
echo "6. Remove prefix matching pattern: ${path/#\/home}" 
echo -e "\nOriginal animal: $animal"
echo "7. Replace first match (cat -> mouse): ${animal/cat/mouse}"
echo "8. Replace all matches (cat -> mouse): ${animal//cat/mouse}"
echo -e "\nOriginal filename: $filename"
echo "9. Replace suffix (txt -> csv): ${filename/%txt/csv}" 
echo -e "\nOriginal greeting: $greeting"
echo "10. Replace prefix (hello -> hi): ${greeting/#hello/hi}"
echo -e "\n11. Length of foo: ${#foo}"
combo="my.resume.final.pdf"
base="${combo%%.*}"
ext="${combo##*.}"
echo -e "\nBonus:"
echo "Base: $base"
echo "Extension: $ext"
================================================

str="HELLO WORLD!"
echo "${str,}"   #=> "hELLO WORLD!" (lowercase 1st letter)
echo "${str,,}"  #=> "hello world!" (all lowercase)

str="hello world!"
echo "${str^}"   #=> "Hello world!" (uppercase 1st letter)
echo "${str^^}"  #=> "HELLO WORLD!" (all uppercase)

=======================================================

unset foo
echo "Original foo is unset."
echo
# 1️⃣ ${foo:-val} → Value if unset or null (but doesn't set it)
echo "1. Value of foo (or default if unset): ${foo:-default_value}"
echo "After this, foo is still unset: $foo"
echo

# 2️⃣ ${foo:=val} → Assign value if unset or null (sets foo)
echo "2. Assign default to foo if unset: ${foo:=default_assigned}"
echo "Now foo is set to: $foo"
echo

# 3️⃣ ${foo:+val} → Return this value *if foo is set*
echo "3. If foo is set, use this value: ${foo:+custom_value}"
echo "Current foo: $foo"
echo

# 4️⃣ ${bar:?Error message} → Show error and exit if bar is unset/null
# Uncomment below to see it in action:
# echo "4. If bar is unset, show error: ${bar:?bar is not set! Exiting...}"

# To demonstrate with bar set:
bar="exists"
echo "4. With bar set: ${bar:?bar is not set!}"

prefix_a=one
prefix_b=two
echo ${!prefix_*}  # all variables names starting with `prefix_`
                    # prefix_a prefix_b

LOOPS



for i in /etc/rc.*; do
  echo "$i"
done


for ((i = 0 ; i < 100 ; i++)); do
  echo "$i"
done

while read -r line; do
  echo "$line"
done <file.txt



while true; do
  ···
done

for i in {1..5}; do
    echo "Welcome $i"
done

for i in {5..50..5}; do
    echo "Welcome $i"
done

=======================================================
$# 	Number of arguments
$* 	All positional arguments (as a single word)
$@ 	All positional arguments (as separate strings)
$1 	First argument
$_ 	Last argument of the previous command
======================================================
[[ -z STRING ]] 	Empty string
[[ -n STRING ]] 	Not empty string
[[ STRING == STRING ]] 	Equal
[[ STRING != STRING ]] 	Not Equal
[[ NUM -eq NUM ]] 	Equal
[[ NUM -ne NUM ]] 	Not equal
[[ NUM -lt NUM ]] 	Less than
[[ NUM -le NUM ]] 	Less than or equal
[[ NUM -gt NUM ]] 	Greater than
[[ NUM -ge NUM ]] 	Greater than or equal
[[ STRING =~ STRING ]] 	Regexp
(( NUM < NUM )) 	Numeric conditions
[[ -o noclobber ]] 	If OPTIONNAME is enabled
[[ ! EXPR ]] 	Not
[[ X && Y ]] 	And
[[ X || Y ]] 	Or
====================================================

[[ -e FILE ]] 	Exists
[[ -r FILE ]] 	Readable
[[ -h FILE ]] 	Symlink
[[ -d FILE ]] 	Directory
[[ -w FILE ]] 	Writable
[[ -s FILE ]] 	Size is > 0 bytes
[[ -f FILE ]] 	File
[[ -x FILE ]] 	Executable
[[ FILE1 -nt FILE2 ]] 	1 is more recent than 2
[[ FILE1 -ot FILE2 ]] 	2 is more recent than 1
[[ FILE1 -ef FILE2 ]] 	Same files

==================================================

# String
if [[ -z "$string" ]]; then
  echo "String is empty"
elif [[ -n "$string" ]]; then
  echo "String is not empty"
else
  echo "This never happens"
fi
=================================================
# Combinations
if [[ X && Y ]]; then
  ...
fi

# Equal
if [[ "$A" == "$B" ]]

# Regex
if [[ "A" =~ . ]]

if (( $a < $b )); then
   echo "$a is smaller than $b"
fi

if [[ -e "file.txt" ]]; then
  echo "file exists"
fi
=====================================================================================
text="Asdfghjkl"
if [[ $text =~ . ]]; then
    echo "Match! '$text' has at least one character."
else
    echo "No match."
fi


word="hello123"


if [[ $word =~ ^[a-zA-Z]+$ ]]; then
    echo "Only letters"
else
    echo "Not only letters"
fi
if [[ $word =~ ^h.*[0-9]$ ]]; then
    echo "Starts with 'h' and ends with a digit"
fi
word="abc123"
if [[ $word =~ [0-9] ]]; then
    echo "The word contains at least one digit."
else
    echo "The word has no digits."
fi
===========================================================================================================================
Defining arrays

Fruits=('Apple' 'Banana' 'Orange')
Veggies=('A' 'B' 'C')
Fruits[0]="Apple"
Fruits[1]="Banana"
Fruits[2]="Orange"

echo "${Fruits[0]}"           # Element #0
echo "${Fruits[-1]}"          # Last element
echo "${Fruits[@]}"           # All elements, space-separated
echo "${#Fruits[@]}"          # Number of elements
echo "${#Fruits}"             # String length of the 1st element
echo "${#Fruits[3]}"          # String length of the Nth element
echo "${Fruits[@]:3:2}"       # Range (from position 3, length 2)
echo "${Fruits[@]:1:2}"  
echo "${!Fruits[@]}"          # Keys of all elements, space-separated

# Iteration

for i in "${Fruits[@]}"; do
  echo "$i"
done

Fruits=("${Fruits[@]}" "Watermelon")    # Push
Fruits+=('Watermelon')                  # Also Push
Fruits=( "${Fruits[@]/Ap*/}" )          # Remove by regex match
unset Fruits[2]                         # Remove one item
Fruits=("${Fruits[@]}")                 # Duplicate
Fruits=("${Fruits[@]}" "${Veggies[@]}") # Concatenate
# lines=(`cat "logfile"`)                 # Read from file
# Iteration
for i in "${Fruits[@]}"; do
  echo "$i"
done
========================================================================================================================================
Dictionaries

declare -A sounds
sounds[dog]="bark"
sounds[cow]="moo"
sounds[bird]="tweet"
sounds[wolf]="howl"


echo "${sounds[dog]}" # Dog's sound
echo "${sounds[@]}"   # All values
echo "${!sounds[@]}"  # All keys
echo "${#sounds[@]}"  # Number of elements
unset sounds[dog]     # Delete dog

for val in "${sounds[@]}"; do
  echo "$val"
done
for key in "${!sounds[@]}"; do
  echo "$key"
done
=============================================================

declare -i count  # Declare as type integer
count+=1          # Increment
echo $count
count+=1          # Increment
echo $count

echo $(($RANDOM%200))
echo $(($RANDOM%200))
=======================================================================

-c 	Operations apply to characters not in the given set
-d 	Delete characters
-s 	Replaces repeated characters with single occurrence
-t 	Truncates
[:upper:] 	All upper case letters
[:lower:] 	All lower case letters
[:digit:] 	All digits
[:space:] 	All whitespace
[:alpha:] 	All letters
[:alnum:] 	All letters and digits
Example

echo "Welcome To Devhints" | tr '[:lower:]' '[:upper:]'
WELCOME TO DEVHINTS

echo  "abc123" | tr -d [:digit:]
# Output: abc   → digits are deleted

echo  "abc123" | tr -cd [:digit:]
# Output: 123   → deletes everything **except** digits
echo
echo "heeeellooo     world!!" | tr -s " "
# Output: heeeellooo world!!
echo "aaabbbcccaaa" | tr -s "a" | tr -s "b" | tr -s "c"
# Output: abbbccca
echo "abcdef" | tr -t abc 123
# Output: 123def   → replaces a→1, b→2, c→3, rest unchanged
echo "Hello World" | tr [:upper:] [:lower:]
# Output: hello world
echo "bash script" | tr [:lower:] [:upper:]
# Output: BASH SCRIPT
echo "a b	c  d" | tr -d [:space:]
# Output: abcd
echo
echo "Helloooo!!!    1234" | tr -cd [:alnum:]
# Output: Helloooo1234
echo
echo "hello123!!" | tr -cd [:alpha:]
# Output: hello   → keeps only alphabetic letters
echo
echo "hello123!!" | tr -cd [:alnum:]
# Output: hello123 → keeps only letters and numbers
echo
===========================================================
python hello.py > output.txt            # stdout to (file)
python hello.py >> output.txt           # stdout to (file), append
python hello.py 2> error.log            # stderr to (file)
python hello.py 2>&1                    # stderr to stdout
python hello.py 2>/dev/null             # stderr to (null)
python hello.py >output.txt 2>&1        # stdout and stderr to (file), equivalent to &>
python hello.py &>/dev/null             # stdout and stderr to (null)
echo "$0: warning: too many users" >&2  # print diagnostic message to stderr

python hello.py < foo.txt      # feed foo.txt to stdin for python
diff <(ls -r) <(ls)            # Compare two stdout without files
==========================================================


command -V cd
=> "cd is a function/alias/whatever"



while [[ "$1" =~ ^- && ! "$1" == "--" ]]; 
do 
case $1 in
  -V | --version )
    echo "$version"
    exit
    ;;
  -s | --string )
    shift; string=$1
    ;;
  -f | --flag )
    flag=1
    ;;
esac; shift; done
if [[ "$1" == '--' ]]; then shift; fi
===========================================
echo -n "Proceed? [y/n]: "
read -r ans
echo "$ans"

=================================================

printf "Hello %s, I'm %s" Sven Olga
#=> "Hello Sven, I'm Olga
printf "\n"
printf "1 + 1 = %d" 2
#=> "1 + 1 = 2"
printf "\n"
printf "This is how you print a float: %f" 2
#=> "This is how you print a float: 2.000000"
printf "\n"
printf '%s\n' '#!/bin/bash' 'echo hello' >file
# format string is applied to each group of arguments
printf '%i+%i=%i\n' 1 2 3  4 5 9

$? 	Exit status of last task
$! 	PID of last background task
$$ 	PID of shell
$0 	Filename of the shell script
$_ 	Last argument of the previous command
${PIPESTATUS[n]} 	return value of piped commands (array)


====================================================

echo foo
ls
if grep -q 'foo' ~/.bash_history; then
  echo "You appear to have typed 'foo' in the past"
fi


