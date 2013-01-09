#!/bin/sh
#this script is released under the MIT Public License

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
#Limit temperature when we switch from 3 to 2 while going down
LIMIT_2_DOWN=65

#We start at max just to be safe 
STATE=3


#a dirty function to get the temperature
get_max_temperature(){
    NEW_MAX_TEMP=0
    for i in `cat /proc/acpi/ibm/thermal|sed "s/temperatures://"`
    do
    if [ $i -gt $NEW_MAX_TEMP ]; then
        NEW_MAX_TEMP=$i
    fi
    done
    
    #We update only if we realy have a new value
    if [ $NEW_MAX_TEMP -gt 0 ]
    then
         MAX_TEMP=$NEW_MAX_TEMP
    fi
}

#the function regulating the fan
regula_fan(){
    #Getting the state
    if [ $MAX_TEMP -gt $LIMIT_1_UP ] && [ $STATE -eq 1 ]
        then STATE=2
    elif [ $MAX_TEMP -lt $LIMIT_1_DOWN ]
        then STATE=1
    elif [ $MAX_TEMP -gt $LIMIT_2_UP ]
        then STATE=3
    elif [ $MAX_TEMP -lt $LIMIT_2_DOWN ] && [ $STATE -eq 3 ]
        then STATE=2
    fi
    
    #Setting the fan speed
    case $STATE in
        1) echo level $STATE_1_LEVEL >/proc/acpi/ibm/fan;;
        2) echo level $STATE_2_LEVEL >/proc/acpi/ibm/fan;;
        3) echo level $STATE_3_LEVEL >/proc/acpi/ibm/fan;;	
        :) echo level 7 >/proc/acpi/ibm/fan;; #just to be safe
esac	
}

#infinite loop
while [ 1 ]
do
	get_max_temperature
	regula_fan
	sleep 1
done
