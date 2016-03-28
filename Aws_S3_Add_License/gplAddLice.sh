#! /bin/bash

#zipAddFile
function zipAddLice {
    cp /home/kaith/awsS3/LICENSE.txt LICENSE.txt
    zip -r "$1" LICENSE.txt
    rm LICENSE.txt
}
function rarAddLice {
    cp /home/kaith/awsS3/LICENSE.txt LICENSE.txt
    rar u "$1" LICENSE.txt
    rm LICENSE.txt
}

function tarAddLice {
fold=$(echo "$1" | grep '\.tar\|\.rar\|\.zip\|\.tgz'|sed -e 's/ *$//'|sed 's/.* //g'|sed 's/.tar.*//g'|sed 's/.zip.*//g'|sed 's/.tgz.*//g')
mkdir $fold
tar -xvf $1 -C $fold
cp /home/kaith/awsS3/LICENSE.txt $fold
rm "$1"
tar cvfj "$fold".tar.bz2 $fold
rm $fold -rf
}

gplIndex=($(cat /home/kaith/awsS3/dlink-gpl.txt))
for i in "${gplIndex[@]:31:1}"
do
    #Get gpl File Name One by one
    gplPreFolder=$i
    readarray -t gplArch <<< "$(aws s3 ls s3://dlink-gpl/$i |grep '\.tar\.gz$\|\.tar\.bz2$\|\.rar\|\.zip\|\.tgz'|sed 's/^....-..-.. ..:..:.. *[0-9]* //g')"
    #Download Files
    aws s3 sync s3://dlink-gpl/$i .
    
    #Verify if there is GPL Archive files
    if ! [ -z "$gplArch" ]; then
        #Verify the type of Archive Files
        for i in "${gplArch[@]}"
            #echo $i
        do
        if [[ $gplArch == *".rar" ]]; then
            rarAddLice "$i"
            #upload
        elif [[ $gplArch == *"tar"* ]]; then
            tarAddLice "$i"
            #upload
        elif [[ $gplArch == *"tgz"* ]]; then
            tarAddLice "$i"
            #upload
        elif [[ $gplArch == *".zip" ]]; then
            zipAddLice "$i"
            echo getin!!!!
            #upload
        else
        echo $i has no GPL archives files!------------- >> /home/kaith/awsS3/gplAddLice_noArch.log
        fi
        #upload
        done
    aws s3 sync . s3://dlink-gpl/CJ_TEST/$gplPreFolder
    fi
unset gplArch
sleep 1
rm * -rf
done
echo finished
