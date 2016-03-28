#! /bin/bash

gplIndex=($(cat /home/kaith/awsS3/dlink-gpl.txt))                               
for i in "${gplIndex[@]:31:1}"                                                 
do                                                                              
        #Get gpl File Name One by one                                               
            #gplArch=($(aws s3 ls s3://dlink-gpl/CJ_TEST/GPL1100075/ |grep '\.tar\.gz$\|\.tar\.bz2$\|\.rar\|\.zip\|\.tgz'|sed -e 's/ *$//'|sed 's/.* //g'))
            a=$i
            gplArch=($(aws s3 ls s3://dlink-gpl/$i |grep '\.tar\.gz$\|\.tar\.bz2$\|\.rar\|\.zip\|\.tgz'|sed 's/^....-..-.. ..:..:.. *[0-9]* //g'))
            for i in "${gplArch[@]}"
            do
            echo $i in $a !!
            done
done
