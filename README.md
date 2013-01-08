thinkfan-sh
===========

simple fan control script for thinkpad

## License ###

thinkfan-sh is released under the MIT Public License

## Description ##

``thinkfan.sh`` is just a very simple script that handle temperature 
for thinkpad computers under linux using ``/proc/acpi/ibm/fan``.

## Disclaimer ##

This script plays arround your fan speed, so it could be a dangerous for your computer. Use it with care 

A nice visible temperature widget might be a good idea.

## Using the script ##

Just run it!

One way to use it is to simply put it inside ``/usr/local/bin/`` and to add ``/usr/local/bin/thinkfan.sh &`` 
inside ``/etc/rc.local``

On some distros you may need to add ``thinkpad_acpi.fan_control=1`` to your kernel comand line 
(hint, look at ``/boot/grub/grub.cfg``)

## Principle ##

This script has three "temperature states": low (1), mid (2), high (2) and works like that:

Let say you start at low (1), and your computer heats up, the temperature will go over "LIMIT_1_UP", 
the new state is set to mid (2), and it will remain at mid (2) unless the temperature goes under 
"LIMIT_1_DOWN" (or becomes higher than "LIMIT_2_UP").

"LIMIT_1_UP" is greater than "LIMIT_1_DOWN" in order to prevent the fan to switch every second from low to mid.

The same principal is used to switch between mid (2) and high (3).

## Tuning the script ##

There are several things you can tun inside this script:

You can tun the value of LIMIT_1_UP, LIMIT_1_DOWN, LIMIT_2_UP and LIMIT_2_DOWN 
(it's the temperature thresholds in Celsius degree).

You can also tun the value sent to ``/proc/acpi/ibm/fan``.

For example my thinkpad x60 can handle a ``level 0`` in idle.

Hope it could help a little to make your thinkpad quieter.
