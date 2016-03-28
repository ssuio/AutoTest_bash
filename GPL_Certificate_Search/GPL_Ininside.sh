#!/bin/bash


function rarCASearch()
{
if $(unrar l $1|grep -q '\.pfx\|\.spc\|\.pvk'); then
    echo Found Leaking Files in "$(tput setaf 3)$1$(tput sgr 0)" files
    unrar l $1|grep '\.pfx\|\.spc\|\.pvk' --color
    echo $(tput setab 6)-----------------------------------$(tput sgr 0)

fi
}

function tarCASeach()
{
if $(tar -tf $1|grep -q '\.pfx\|\.spc\|\.pvk'); then
    echo "Found Leaking Files in $(tput setaf 3)$1$(tput sgr 0) files"
    tar -tf $1|grep '\.pfx\|\.spc\|\.pvk' --color
    echo $(tput setab 6)-----------------------------------$(tput sgr 0)

fi
}


function zipCASearch()
{
if $(unzip -l $1|grep -q '\.pfx\|\.spc\|\.pvk'); then
    echo "Found Leaking Files in $(tput setaf 3)$1$(tput sgr 0)  files"
    unzip -l $1|grep '\.pfx\|\.spc\|\.pvk' --color
    echo $(tput setab 6)-----------------------------------$(tput sgr 0)
fi
}

function AllCASearch()
{
     if [[ $1 == *".rar" ]]; then
#        echo 'RAR found in '$1
        rarCASearch $1 
#        echo 'Doing' $1 'RAR Search'

    elif [[ $1 == *"tar"* ]]; then
#        echo 'TAR found in '$1
        tarCASeach $1 
#        echo 'Doing' $1 'TAR Search'


    elif [[ $1 == *"tar"* ]]; then
#        echo 'ZIP found in'$1
        zipCASearch $1 
#        echo 'Doing' $1 'ZIP Search'
    fi


}

function DirCASearch()
{
    if $(find $1 |grep -q '\.pfx\|\.spc\|\.pvk'); then
        #echo "Found Leak files 1s in '<' "$(tput setaf 3)$1$(tput sgr 0)" '>' as belowing files"
        find $1 |grep --color '\.pfx\|\.spc\|\.pvk'
    #else
    #    echo "No leaking files in "$(tput setaf 3)$1""   
    fi
}

function ArchiveSearch()
{
     DirCount=$[$DirCount +1]
     if [[ $1 == *".rar" ]]; then
#        echo 'RAR found in '$1
        AllCASearch $1
        rarSearch $1 $DirCount
#        echo 'Doing' $1 'RAR Search'

    elif [[ $1 == *"tar"* ]]; then
#        echo 'TAR found in '$1
        AllCASearch $1
        tarSeach $1 $DirCount
#        echo 'Doing' $1 'TAR Search'


    elif [[ $1 == *"tar"* ]]; then
#        echo 'ZIP found in'$1
        AllCASearch $1
        zipSearch $1 $DirCount
#        echo 'Doing' $1 'ZIP Search'
    fi
}



function rarSearch()
{
if $(unrar l $1|grep -q '\.tar\|\.rar\|\.zip');then
     mkdir ntemp/$2
 #   echo Found Archive in $1
    archType=$(unrar l $1|grep '\.tar\|\.rar\|\.zip'|sed '1,1d'|sed -e 's/ *$//'|sed 's/.* //g')
    readarray -t arr <<<"$archType"
    unrar x $1 ntemp/$2/ > /dev/null 2>&1 &
    ## After extract , just continue check CA files, because I need the path! 
    if $(DirCASearch ntemp/$2|grep -q '\.pfx\|\.spc\|\.pvk');then
        echo Found Leaking Files in "$(tput setaf 3)$file$(tput sgr 0)"
        DirCASearch ntemp/$2|grep  '\.pfx\|\.spc\|\.pvk' --color
        echo $(tput setab 6)-----------------------------------$(tput sgr 0)
    fi
#    echo "extract $1 to $2/"
    for i in "${arr[@]}"
    do
        ArchiveSearch ntemp/$2'/'$i
#        echo $1 'is doing ArchiveSearch from ' "ntemp/$2/$i"
    done
fi
}

function tarSeach()
{
if $(tar -tf $1|grep -q '\.rar\|\.tar|\.zip');then
     mkdir ntemp/$2
#   echo Found Archive in $1
    archType=$(unrar l $1|grep '\.tar\|\.rar\|\.zip'|sed '1,1d'|sed -e 's/ *$//'|sed 's/.* //g')
    readarray -t arr <<<"$archType"
    tar -xvf $1 -C ntemp/$2/ > /dev/null 2>&1 & 
    ## After extract , just continue check CA files, because I need the path! 
    if $(DirCASearch ntemp/$2|grep -q '\.pfx\|\.spc\|\.pvk');then
        echo Found Leaking Files in "$(tput setaf 3)$file$(tput sgr 0)"
        DirCASearch ntemp/$2|grep --color '\.pfx\|\.spc\|\.pvk'
        echo $(tput setab 6)-----------------------------------$(tput sgr 0)
    fi
#    echo "extract $1 to $2/"
    for i in "${arr[@]}"
    do
        ArchiveSearch ntemp/$2'/'$i
#        echo $1 'is doing ArchiveSearch from ' "ntemp/$2/$i"
    done

fi
}

function zipSearch()
{
if $(unzip -l $1|grep -q '\.rar\|\.tar|\.zip');then
     mkdir ntemp/$2
#    echo Found Archive in $1
    archType=$(unzip -l $1|grep '\.tar\|\.rar\|\.zip'|sed '1,1d'|sed -e 's/ *$//'|sed 's/.* //g')
    readarray -t arr <<<"$archType"
    unzip $1 -d ntemp/$2/ > /dev/null 2>&1 &
    ## After extract , just continue check CA files, because I need the path! 
    if $(DirCASearch ntemp/$2|grep -q '\.pfx\|\.spc\|\.pvk');then
        echo Found Leaking Files in "$(tput setaf 3)$file$(tput sgr 0)" 
        DirCASearch ntemp/$2|grep --color '\.pfx\|\.spc\|\.pvk'
        echo $(tput setab 6)-----------------------------------$(tput sgr 0)
    fi
#    echo "extract $1 to $2/"
    for i in "${arr[@]}"
    do
        ArchiveSearch ntemp/$2'/'$i
#        echo $1 'is doing ArchiveSearch from ' "ntemp/$2/$i"
    done

fi
}

mkdir ntemp

echo ---------------------------------------------
echo Give me a test folder or use \".\" as pwd path.
echo ---------------------------------------------
read TestDir
echo $(tput setab 6)-----------------------------------$(tput sgr 0)


for file in $TestDir/*
do
    count=$[$count+1]
    ArchiveSearch $file
    echo \["$(tput setaf 1)No.$count $file FINISHED$(tput sgr 0)"\]
done 
#for ((d=1 ; d<=$DirCount; d++))
#do
#   DirCASearch ntemp/$d
#done

rm ntemp -r 
echo Remove Temp Folder
echo ------------END---------------
