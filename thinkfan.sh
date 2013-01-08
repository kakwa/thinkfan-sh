#!/bin/sh

#fan speed for the different states
STATE_1_LEVEL=1
STATE_2_LEVEL=5
STATE_3_LEVEL=7

#Limit temperature when we switch from 1 to 2 while going up
LIMIT_1_UP=65
#Limit temperature when we switch from 2 to 1 while going down
LIMIT_1_DOWN=60

#Limit temperature when we switch from 2 to 3 while going up
LIMIT_2_UP=75
#Limit temperature when we switch from 2 to 1 while going down
LIMIT_2_DOWN=65

CURRENT_LIMIT_UP=$LIMIT_1_UP
CURRENT_LIMIT_DOWN=$LIMIT_0_UP
STATE=1

get_max_temperature(){
  MAX_TEMP=`cat /proc/acpi/ibm/thermal |sed "s/temperatures:\|-128//g"|sed "s/\([0-9]\)\ /\1\n/g"|sort -r|head -n 1`
}

regula_fan(){
if [ $MAX_TEMP -gt $LIMIT_1_UP ] && [ $STATE -eq 1 ]
	then STATE=2
elif [ $MAX_TEMP -lt $LIMIT_1_DOWN ]
	then STATE=1
elif [ $MAX_TEMP -gt $LIMIT_2_UP ]
	then STATE=3
elif [ $MAX_TEMP -lt $LIMIT_2_DOWN ] && [ $STATE -eq 3 ]
	then STATE=2
fi
case $STATE in
	1) echo level $STATE_1_LEVEL >/proc/acpi/ibm/fan;;
	2) echo level $STATE_2_LEVEL >/proc/acpi/ibm/fan;;
	3) echo level $STATE_3_LEVEL >/proc/acpi/ibm/fan;;	
	:) echo level 7 >/proc/acpi/ibm/fan;;
esac	
}

while [ 1 ]
do
	get_max_temperature
	regula_fan
	sleep 1
done
