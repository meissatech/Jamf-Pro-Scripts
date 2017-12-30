#!/bin/sh
 
# Sets computer name to the name that was used to bind to AD

ADname="N/A"
ADname=$(sudo dsconfigad -show)
 
if [ "$ADname" == "" ]
then
    echo "This computer is NOT bound to Active Directory!"
else
    ADname=$(sudo dsconfigad -show | grep Computer\ Account | cut -d'=' -f2 | tr -d '$ ')
    #ADnameLength=$(#ADname)
    #ADnameLastCharacter=${ADname:$length-1:1}
   
    #if["ADnameLastCharacter" == "$"]
    #then
    #    ADname=${ADname:0:length-1}
    #fi
   
    echo
    echo "This computer's Active Directory name is: $ADname"
    echo
fi
   
 
scutil --set ComputerName $ADname
scutil --set LocalHostName $ADname
scutil --set HostName $ADname

exit 0

