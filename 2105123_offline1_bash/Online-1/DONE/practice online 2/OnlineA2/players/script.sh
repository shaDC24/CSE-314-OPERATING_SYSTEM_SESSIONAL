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

