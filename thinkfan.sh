#!/bin/sh

LIMIT_1_UP=65
LIMIT_1_DOWN=60
LIMIT_2_UP=75
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
	1) echo level 1 >/proc/acpi/ibm/fan;;
	2) echo level 5 >/proc/acpi/ibm/fan;;
	3) echo level 7 >/proc/acpi/ibm/fan;;	
	:) echo level 7 >/proc/acpi/ibm/fan;;
esac	
}

get_max_temperature
while [ 1 ]
do
	get_max_temperature
	regula_fan
	sleep 1
done
