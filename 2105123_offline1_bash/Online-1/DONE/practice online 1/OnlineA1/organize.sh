
if [[ $# -lt 5 ]];
then
    echo "The command should like : <submissions> <targets> <tests> <answers> [-optional flags]"
else
    allowed_flags=("-v" "-noexecute" "-nolc" "-nofc" "-nocc")
        for (( i=5; i<=$#; i++ )); do
            arg="${!i}"
            if [[ "$arg" == -* ]]; then
                found=false
                for flag in "${allowed_flags[@]}"; do
                    if [[ "$arg" == "$flag" ]]; then
                        found=true
                        break
                    fi
                done
                if ! $found; then
                    echo "Unknown flag: $arg"
                fi
            fi
        done



    submissionFolder="$1"
    targetFolder="$2"
    if [[ ! -d "$targetFolder" ]];
    then 
    mkdir -p "$targetFolder"
    fi
    testFolder="$3"
    answerFolder="$4"

    v=false
    noexecute=false
    nolc=false
    nocc=false
    nofc=false


    csvFile="$targetFolder/results.csv"


    for args in "$@";
    do
    case "$args" in
    -v)v=true
    ;;
    -noexecute)noexecute=true
    ;;
    -nolc)nolc=true
    ;;
    -nocc)nocc=true
    ;;
    -nofc)nofc=true
    ;;
    esac
    done

    initiateCSV()
    {
    csv_header="student_id,student_name,language"
    [[ $noexecute == false ]] && csv_header+=",matched,not_matched"
    [[ $nolc == false ]] && csv_header+=",line_count"
    [[ $nocc == false ]] && csv_header+=",comment_count"
    [[ $nofc == false ]] && csv_header+=",function_count"


    echo "$csv_header" > "$csvFile"

    }


    extractStudentName()
    {
        passedArguement="$1" 
        name="${passedArguement%%_*}"
        echo "$name"
    }
    extractStudentId()
    {
        passedArguement="$1"
        studentId="${passedArguement:(-7):7}"
        echo "$studentId"
    }

    unzipFolder()
    {
        fileName="$1"
        unzFile="$2"
        if [[ ! -d "$unzFile" ]]; then
            unzip -q "$fileName" -d "$unzFile"
        fi

    }

    makeFolder()
    {
    newFolder="$1"
    if [[ ! -d $newFolder ]];
    then
    mkdir -p $newFolder
    fi
    }

    organizeFiles()
    {
        i="$1"
        folder="$2"
        studentId="$3"
        extnsion="$4"
        csv_line="$5"
        targetDir="$targetFolder/$folder/$studentId"
        returnFileName="$targetDir/main.$extns"
        if [[ "$extns" == "java" ]];
        then
        returnFileName="$targetDir/Main.$extns"
        fi

        makeFolder "$targetDir"
        if [[ ! -e "$returnFileName" ]];
        then
        cp "$i" "$returnFileName"
        fi

        echo "Organizing Files for $studentId "
        if [[ $noexecute == false ]];
        then 
        executeFiles "$returnFileName" "$extns" "$csv_line"
        echo "Executing files for $studentId"
        fi 

        if [[ $nolc == false ]];
        then
        line_count=$(lineCount "$returnFileName")
        csv_line+=",$line_count" 
        fi 
        if [[ $nocc == false ]];
        then
        comment_count=$(commentCount "$returnFileName" "$extns")
        csv_line+=",$comment_count"
        fi 
        if [[ $nofc == false ]];
        then 
        function_count=$(functionCount "$returnFileName" "$extns")
        csv_line+=",$function_count"
        fi

        # echo "$csv_line"

    }

    lineCount()
    {
        cnt=$(cat "$1" | wc -l)
        echo "$cnt"
    }

    commentCount()
    {
    extns="$2"
    cmnt=0

    if [[ "$extns" ==  "c" || "$extns" ==  "cpp" || "$extns" ==  "java" ]];
    then
    cmnt=$(grep  -c "//" "$1")
    elif [[ "$extns" == "py" ]];
    then
    cmnt=$(grep  -c "#" "$1")
    fi
    echo "$cmnt"
    }


    functionCount() {
    
        file="$1"
        extns="$2"
        count=0

        case "$extns" in
        c|cpp)
            count=$(grep -E -c '^[[:space:]]*[[:alpha:]_][[:alnum:]_[:space:]\*]*[[:space:]]+[[:alpha:]_][[:alnum:]_]*[[:space:]]*\([^;]*\)[[:space:]]*\{' "$file")
            ;;
        java)
        count=$(grep -E -c '^[[:space:]]*(public|private|protected)?[[:space:]]*(static|final|synchronized)?[[:space:]]*[[:alpha:]_][[:alnum:]_[:space:]\*]*[[:space:]]+[[:alpha:]_][[:alnum:]_]*[[:space:]]*\([^;]*\)[[:space:]]*\{' "$file")
        ;;
        py)
            count=$(grep -E -c '^[[:space:]]*def[[:space:]]+[[:alnum:]_]+\(' "$file")
            ;;
        *)
            echo "Unsupported file type"
            ;;
        esac

        echo "$count"
    }


    executeFiles()
    {
    
    mainFile="$1"
    extns="$2"
    mainPathDir="${mainFile%/*}"
    case "$extns" in
    c)
    gcc "$mainFile" -o "$mainPathDir/main.out";
    executeCmd="$mainPathDir/main.out"

    ;;
    cpp)
    g++ "$mainFile" -o "$mainPathDir/main.out";
    executeCmd="$mainPathDir/main.out"

    ;;
    py)
    executeCmd="python3 $mainFile"

    ;;
    java)
    javac "$mainFile";
    executeCmd="java -cp $mainPathDir Main"

    ;;
    *)
            echo "Unsupported file type"
    ;;
    esac

    executingCommands "$executeCmd" "$mainPathDir" "$extns" "$3"

    }

    executingCommands()
    {
    executeCmd="$1"
    mainPathDir="$2"
    extns="$3" 
    csv_line="$4"  
    testnum=0
    matched=0
    unmatched=0

    for testFile in "$testFolder"/*.txt;
    do

        inputFile="$testFile"
        testFile="${testFile##*/}"
        testFile="${testFile%.txt}"
        testnum=${testFile:(-1):1}

        outputFile="$mainPathDir/out$testnum.txt"
        answerFile="$answerFolder/ans$testnum.txt"
        if [[ "$extns" == "c" || "$extns" == "cpp" ]];
        then
        "$executeCmd" < "$inputFile" > "$outputFile"
        else
        $executeCmd < "$inputFile" > "$outputFile"
        fi

        if [[ $(diff -q "$outputFile" "$answerFile") == "" ]]; then
            ((matched++))
        else
            ((unmatched++))
        fi


    done

    csv_line+=",$matched,$unmatched"

    } 




    if [[ "$v" == true ]];
    then 
        initiateCSV
        for zipFileName in "$submissionFolder"/*.zip;
        do 
        zipBaseName="${zipFileName##*/}"  
        zipPathDir="${zipFileName%/*}"

        studentName=$(extractStudentName "$zipBaseName")
        studentId=$(extractStudentId "${zipBaseName%.zip}")

        unzipFolderName="$zipPathDir/temp_$studentId"
        unzipFolder  "$zipFileName" "$unzipFolderName"
        csv_line="$studentId,$studentName"
        for extns in c cpp py java ;
            do
            extractedFiles=$(find "$unzipFolderName" -type f -name "*.$extns")
            if [[ -n "$extractedFiles" ]];
                then
                    for i in "$extractedFiles";
                        do
                            case $extns in 
                            c)
                            csv_line+=',"C"';
                            organizeFiles "$i" "C" "$studentId" "$extns" "$csv_line";
                            ;;
                            cpp)
                            csv_line+=',"C++"';
                            organizeFiles "$i" "C++" "$studentId" "$extns" "$csv_line";
                        
                            ;;
                            py)
                            csv_line+=',"Python"';
                            organizeFiles "$i" "PYTHON" "$studentId" "$extns" "$csv_line";
                            
                            ;;
                            java)

                            csv_line+=',"Java"';
                            organizeFiles "$i" "JAVA" "$studentId" "$extns" "$csv_line";
                        
                            ;;
                            *)
                            ;;
                            esac
                        echo "$csv_line" >> "$csvFile"
                    done
                fi
            done
        done

    for temp_dir in "$submissionFolder"/temp_*; do
        [[ -d "$temp_dir" ]] && rm -rf "$temp_dir"
    done
    echo "All submissions processed successfully"
    fi
fi
