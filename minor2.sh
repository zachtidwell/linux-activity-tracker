#Zachary Tidwell
#CSCE 3600.004
#10/21/2022
#This program checks the status of currently logged in users of the CSE linux machines.

#!/bin/bash


#When ^C (SIGINT) is input to terminal, the trap calls catchC which increments cCount
#Once that counter gets to 2, the program terminates.
cCount=0
trap catchC SIGINT
catchC()				#SIGINT TRAP
{
	let cCount++
	if [[ $cCount == 1 ]]; then	#First SIGINT is caught
		echo $'\n(SIGINT) ignored. enter ^C 1 more time to terminate program. ^C (SIGINT) ignored. enter ^C 1 more time to terminate program.\n'
	else
		echo $'\nTerminating program'
		exit
	fi
}

echo $(date) $'\n'$(who | wc -l) initial users logged in to $HOSTNAME		#Prints date and users logged in at beginning of program

while true
do

if test "$login"; then							#Deletes the files if they exist so the program can write to clean files
rm login
fi
if test "$logout"; then
rm login
fi
if test "$users"; then
rm login
fi
if test "$newUsers"; then
rm login
fi



echo $(date) " )  Users logged in: " $(who | wc -l)			#Prints date and amount of users logged in

who | cut -d' ' -f1 > users						#writes every logged in user to file "users"

sleep 10								#Waits 10 seconds to check again

who | cut -d' ' -f1 > newUsers						#writes every logged in user after the 10 seconds to new file "newUsers"

diff users newUsers | grep ^\> | cut -d' ' -f2 > login			#Reads differences in the 2 files and sends to new files "login" and "logout"
diff users newUsers | grep ^\< | cut -d' ' -f2 > logout

while read i
do
	echo "${i}" has logged in to $HOSTNAME				#Prints every name in the login file
done < login

while read k
do
	echo "${k}" has logged out of $HOSTNAME				#Prints every name in the logout file
done < logout

done
