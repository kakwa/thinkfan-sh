thinkfan-sh
===========

simple fan control script for thinkpad

## License ###

thinkfan-sh is released under the MIT Public License

## Description ##

``thinkfan.sh`` is just a very simple script that handle fan speed 
on thinkpad computers under GNU/Linux using ``/proc/acpi/ibm/fan`` and ``/proc/acpi/ibm/thermal``.

## Disclaimer ##

This script plays around your fan speed, so it could be a dangerous for your computer. Use it carefully.

A nice visible temperature widget might be a good idea. 

Some tuning might also be good.

## Using the script ##

As root:
```shell
curl https://raw.github.com/kakwa/thinkfan-sh/master/thinkfan.sh -o /usr/local/bin/thinkfan.sh
vim /usr/local/bin/thinkfan.sh #edit the value to your taste
chmod 700 /usr/local/bin/thinkfan.sh
/usr/local/bin/thinkfan.sh
```
One way to use it is to simply put it inside ``/usr/local/bin/`` and to add ``/usr/local/bin/thinkfan.sh &`` 
inside ``/etc/rc.local``

On some distros you may need to add ``thinkpad_acpi.fan_control=1`` to your kernel comand line 
(hint, look at ``/boot/grub/grub.cfg``)

## Principle ##

This script has three "fan states": 
* low (1): lowest fan speed
* mid (2): mid fan speed
* high (3): highest fan speed 

It also four "temperature thresholds":
* LIMIT_1_UP: temperature where it switches from 1 to 2 while going up
* LIMIT_1_DOWN: temperature where it switches from 2 to 1 while going down
* LIMIT_2_UP: temperature where it switches from 2 to 3 while going up
* LIMIT_2_DOWN: temperature where it switches from 3 to 2 while going down

It works like that:

* Let say you start at low (1)
* your computer heats up, the temperature will go over "LIMIT_1_UP"
* the new state is set to mid (2)
* it will remain at mid (2) for a while (unless it goes over "LIMIT_2_UP")
* the temperature goes under "LIMIT_1_DOWN" (which is lower than "LIMIT_1_UP")
* the state comes back to low (1)

"LIMIT_1_UP" is greater than "LIMIT_1_DOWN" in order to prevent the fan to switch every second from low to mid.

The same principal is used to switch between mid (2) and high (3) with "LIMIT_2_UP" and "LIMIT_2_DOWN"

## Tuning the script ##

There are several things you can tun inside this script.

The temperature thresholds in Celsius degree:

* LIMIT_1_UP
* LIMIT_1_DOWN
* LIMIT_2_UP
* LIMIT_2_DOWN 

Note that LIMIT_N_DOWN must lower than LIMIT_N_UP

The different fan speeds:
* STATE_1_LEVEL
* STATE_2_LEVEL
* STATE_3_LEVEL

The value is an integer between 0 (fan disabled) and 7 (fan at max speed). 

Note that there could be less than 8 speeds ( 4 and 5 could mean the same speed for example).

The default values are those used on my thinkpad T60 (the hotter one), I can set STATE_1_LEVEL to 0 on my thinkpad x60


------------------------
Hope it could help a little to make your thinkpad quieter.
