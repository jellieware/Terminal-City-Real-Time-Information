#!/usr/bin/env bash
lat=""
lng=""
echo "Please enter city name:"
read name
cname="${name^}"
mapfile -t countries < <(jq --arg sname "$cname" -r '.[] | select(.name == $sname) | .country' world_cities5000.json)
mapfile -t your_array < <(jq --arg sname "$cname" -r '.[] | select(.name == $sname) | .name' world_cities5000.json)
mapfile -t key_lat < <(jq --arg sname "$cname" -r '.[] | select(.name == $sname) | .lat' world_cities5000.json)
mapfile -t key_long < <(jq --arg sname "$cname" -r '.[] | select(.name == $sname) | .lng' world_cities5000.json)
numberofcities=0
for cities in "${your_array[@]}"; do
  echo -e "\e[38;2;173;255;47m  $numberofcities ${countries[$numberofcities]} $cities \e[0m"
  ((numberofcities++))
done
echo "Please choose city:"
read citynumber
echo "-----"
echo -e "\e[38;2;173;255;47mCity:\e[0m"
echo ${countries[$citynumber]} ${your_array[$citynumber]}
if [[ $key_lat == -* ]];then
lat="${key_lat:1}"
lat+="S"
fi
if [[ $key_lat != -* ]];then
lat="${key_lat}"
lat+="N"
fi
if [[ $key_long == -* ]];then
lng="${key_long:1}"
lng+="W"
fi
if [[ $key_long != -* ]];then
lng="${key_long}"
lng+="E"
fi
echo -e "\e[38;2;173;255;47m" "Sunrise:" "\e[0m"
sunwait list rise $lat $long
echo -e "\e[38;2;173;255;47m" "Sunset:" "\e[0m"
sunwait list sunset $lat $long
echo -e "\e[38;2;173;255;47m" "TimeZone:" "\e[0m"
#cargo build --no-default-features
#cargo add tzf-rs --no-default-features
bodhi=$(tzf --lng ${key_long[$citynumber]} --lat ${key_lat[$citynumber]})
temp="${bodhi#\"}"
result="${temp%\"}"
echo "$result"
echo -e "\e[38;2;173;255;47m" "Offset:" "\e[0m"
mapfile -t other_offset < <(jq --arg oname "$result" -r '.[] | select(.timezone_id == $oname) | .dst_offset' timezonesx.json)
myoffset="${other_offset[@]}"
echo "$myoffset"
echo -e "\e[38;2;173;255;47m" "Time:" "\e[0m"
if [[ $myoffset == -* ]];then
offset=$myoffset
fi
if [[ $myoffset != -* ]];then
offset="$myoffset"
fi
myfinaloffset="$offset"
TZ=UTC date --date="$myfinaloffset hours"
echo -e "\e[38;2;173;255;47m" "done" "\e[0m"
sleep 10



  
  
  