#!/bin/bash
. libaccount.sh
#account all the dirs
allblank=0
alltotal=0
allcomment=0

#whether to print according info or not

#okflag : print
#notokflag : not to print
okflag=1
notokflag=0
#per file info
pflag=$notokflag
#per dir info
gflag=$okflag
#invalid file info
invalidflag=$notokflag

function printlastresult()
{
        allvalidcode=0
        allvalidcode=`expr $alltotal-$allcomment-$allblank`
        echo ""
        echo "**************sum account************"
        echo ""
        echo "total code lines    : "$alltotal
        echo "total blank lines   : "$allblank
        echo "total comment lines : "$allcomment
        echo "total valid lines   : "$allvalidcode
        echo ""
        echo "**************sum account************"
}

#init global param for dir account
init

#traverse all the dirs
until [ $# -eq 0 ]
do
#travers the param
loopdir $1
#print per dir result
printaccountresult $1

allblank=`expr $allblank + $gblank`
alltotal=`expr $alltotal + $gtotal`
allcomment=`expr $allcomment + $gcomment`

init
#turn to next param
shift

done
#print the account result
printlastresult
