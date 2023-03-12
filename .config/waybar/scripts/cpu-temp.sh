#!/bin/sh
# Simple script to show the cpu temp formatted to be shown in polybar

temp=$(sensors | grep "Tctl" | sed "s/Tctl: *+//;s/°C  *//" )
if [ 1 -eq "$(echo "$temp > 70 " | bc)" ]; then
    printf "<span color='#FD807E'>🔥 $temp°C </span>";  
elif [ 1 -eq "$(echo "$temp > 50 " | bc)" ]; then
    printf "<span color='#f5a97f'>🔥 $temp°C </span>";
elif [ 1 -eq "$(echo "$temp > 15 " | bc)" ]; then
    printf "<span color='#F3A3BC'>🔥 $temp°C </span>"; 
 
    
fi

