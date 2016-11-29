#!/bin/bash

POWER='⌁ '

battery_info=`ioreg -rc AppleSmartBattery`
current_charge=$(echo $battery_info | grep -o '"CurrentCapacity" = [0-9]\+' | awk '{print $3}')
total_charge=$(echo $battery_info | grep -o '"MaxCapacity" = [0-9]\+' | awk '{print $3}')
external_connected=$(echo $battery_info | grep -o '"ExternalConnected" = [a-zA-Z]\+' | awk '{print $3}')

charged_slots=$(echo "((($current_charge/$total_charge)*10)/3)+1" | bc -l | cut -d '.' -f 1)

if [[ $charged_slots -gt 3 ]]; then
  charged_slots=3
fi

echo -n '#[fg=colour02]'
for i in `seq 1 $charged_slots`; do echo -n "$POWER"; done

if [[ $charged_slots -lt 3 ]]; then
  echo -n '#[fg=colour01]'
  for i in `seq 1 $(echo "3-$charged_slots" | bc)`; do echo -n "$POWER"; done
fi

percentage=$(echo "($current_charge/$total_charge) * 100" | bc -l)
percentage=${percentage%.*}

# if [[ $external_connected = "Yes" ]]; then
#   echo -n '#[fg=colour02]'
# else
#   echo -n '#[fg=colour04]'
# fi

echo -n '#[fg=colour19]'
echo -n "$percentage% "

