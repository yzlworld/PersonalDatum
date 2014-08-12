#!/bin/bash
#print flag : default value is to print
#per file
pflag=1
#per dir
gflag=1
#invalid file
invalidflag=1
#default value
flagok=1

#global variable
gblank=0
gcomment=0
gtotal=0
#temp file suffix
tmpsuffix="tmp"

#per file variable
pblank=0
pcomment=0
ptotal=0

function init()
{
	gblank=0
	gcomment=0
	gtotal=0
	tmpsuffix="tmp"
	pblank=0
	pcomment=0
	ptotal=0
}

#print per file info
function printfileinfo()
{
	if [ "$pflag" -eq "$flagok" ]
	then
	echo "filename: "$1
	echo "total lines: "$ptotal
	echo "blank lines: "$pblank
	echo "comment lines: "$pcomment
	fi
}


#input filename(has path)
#account per file info
function accountonefile()
{
	#/*----*/
	#       /*-----*/
	#//
	#     //
	sed "/^[[:blank:]]*\/\*/,/\*\//d" $1 | sed "/^[[:blank:]]*\/\//d" > $1$tmpsuffix
	tsum=`cat $1 | wc -l`
	tnocom=`cat $1$tmpsuffix | wc -l`
	tnoblank=`sed -e "/^[[:blank:]]*$/d" $1$tmpsuffix | wc -l`
	
	ptotal=`expr $tsum`
	pblank=`expr $tnocom - $tnoblank`
	pcomment=`expr $tsum - $tnocom`
	
	rm -rf $1$tmpsuffix	

	printfileinfo $1
}

#only .c .h file is right
function validfile()
{
        pp=`echo $1 | awk -F"." '{print $NF}'`
        if [ "$pp" = "c" -o  "$pp" = "h" -o "$pp" = "cpp" -o "$pp" = "cc" -o "$pp" = "cxx" ]
        then
                return 1
        else
                return 0
        fi
}

#print file info which is not in the account scope
function printnotinscope()
{
	if [ "$invalidflag" -eq "$flagok" ]
	then
        echo ""
        echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
        echo ""
        echo "file is not in the account scope   : "$1
        echo ""
        echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
	fi
}

#traverse one dir including its subdirs and files
function loopdir()
{
        for file in `ls $1`
        do
                if [ -f $1"/"$file ]
                then
		validfile $file
		ret=`echo $?`
			if [ "$ret" == "1" ]
			then
				accountonefile $1"/"$file
				gblank=`expr $gblank + $pblank`
				gcomment=`expr $gcomment + $pcomment`
				gtotal=`expr $gtotal + $ptotal`
			else
				printnotinscope $1"/"$file
			fi
                fi
                if [ -d $1"/"$file ]
                then
                        echo ""
                        echo direcoty : $1"/"$file
                        loopdir $1"/"$file
                        echo ""
                fi
        done
}

#print per dir info
function printaccountresult()
{
	if [ "$gflag" -eq "$flagok" ]
	then
	validcode=0
	validcode=`expr $gtotal - $gcomment - $gblank`
	echo ""
	echo "*************$1****************"
	echo ""
	echo "total code lines    : "$gtotal
	echo "total blank lines   : "$gblank
	echo "total comment lines : "$gcomment
	echo "total valid lines   : "$validcode
	echo ""
	echo "*************$1***************"
	fi
}
