#!/bin/bash

####################################################################################################################################################################
#TASK 1:-
#Starting in the /opt directory, locate all directories which contain a file called .prune-enable
#In those directories, delete any files named crash.dump
#In those directories, for any file having the suffix ".log", if the file is larger than one megabyte, replace the file with a file containing only the last 20,000 lines.
#Date: 8/8/2021
#Version : V1
####################################################################################################################################################################

#Flushing old data
>/tmp/prune-enable.txt
>/tmp/crash_dump.txt
>/tmp/file_greater_than_1MB.txt

#Locate all directories which contain a file called .prune-enable
echo "`find /opt -type f -name '.prune-enable' -exec dirname {} \;`" >/tmp/prune-enable.txt

if [ ! -s /tmp/prune-enable.txt ]
then 
     echo -e "There are no directory inside /opt containing .prune-enable file.\n"
	 exit 8
else
     echo -e "Below are all the directories containing '.prune-enable' file\n"
	 cat /tmp/prune-enable.txt 
	 echo -e "\n"
fi	 

sleep 3
############################################################################################################################################################
#In those directories, delete any files named crash.dump
while IFS= read -r line
do 
  { 
    find $line  -type f -name 'crash.dump' -exec ls -lrth {} \; >>/tmp/crash_dump.txt
  }
done < "/tmp/prune-enable.txt"

if [[ ! -s /tmp/crash_dump.txt ]]
then 
     echo -e "There are no files named 'crash.dump' present in above directories.\n"
else
     echo -e "Below are all the files named 'crash.dump' and those will be deleted."
	 echo "`awk '{print $NF}' /tmp/crash_dump.txt`" >/tmp/crash_dump.txt
	 cat /tmp/crash_dump.txt
fi
	 
while IFS= read -r line
do 
 {
   rm -rf $line
   rc1=$?
 
    if [[ $rc1 -ne 0 ]]	
    then
        echo -e "File $line not deleted successfully.Please check.\n"
	fi	
 }
done < "/tmp/crash_dump.txt"	
echo -e "\n"   

sleep 3	
############################################################################################################################################################
#In those directories, for any file having the suffix ".log", if the file is larger than one megabyte, replace the file with a file containing only the last 20,000 lines.
while IFS= read -r line
do 
  {
	find $line -type f -name '*.log' -size +1M >> /tmp/file_greater_than_1MB.txt
  }
done < "/tmp/prune-enable.txt"

if [ ! -s /tmp/file_greater_than_1MB.txt ]
then 
    echo -e "There are no files greater than 1MB with suffix '.log' persent in below directories."
	cat /tmp/prune-enable.txt
else
    echo -e "All the below files are larger than one megabyte and will be replaced with a file containing only the last 20,000 lines."
	cat /tmp/file_greater_than_1MB.txt
fi

while IFS= read -r line
do 
  {
	echo "$(tail -20000 $line)" > $line
	rc2=$?
	
       if [[ $rc2 -ne 0 ]]	
       then
           echo -e "File $line not replaced successfully with a file containing only the last 20,000 lines.\n"
       fi	   
  }
done < "/tmp/file_greater_than_1MB.txt"

	

