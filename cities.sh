#!/usr/bin/env bash
lat=""
lng=""
found=""
echo "Please enter city name:"
read name
cname="${name^}"
mapfile -t countries < <(jq --arg sname "$cname" -r '.[] | select(.name | contains($sname)) | .country' world_cities5000.json)
mapfile -t your_array < <(jq --arg sname "$cname" -r '.[] | select(.name | contains($sname)) | .name' world_cities5000.json)
mapfile -t key_lat < <(jq --arg sname "$cname" -r '.[] | select(.name | contains($sname)) | .lat' world_cities5000.json)
mapfile -t key_long < <(jq --arg sname "$cname" -r '.[] | select(.name | contains($sname)) | .lng' world_cities5000.json)
numberofcities=0
for cities in "${your_array[@]}"; do
bodhi=$(tzf --lng ${key_long[$numberofcities]} --lat ${key_lat[$numberofcities]})
temp="${bodhi#\"}"
result="${temp%\"}"
  echo -e "\e[38;2;173;255;47m  $numberofcities ${countries[$numberofcities]} $cities $result \e[0m"
    ((numberofcities++))
    if [[ -n "$cities" ]]; then
        found=1
    else
        found=0
    fi
done
if [[ $found == 1 ]];then
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
echo -e "\e[38;2;173;255;47m" "temp:" "\e[0m"
temp=$(curl -s "https://api.open-meteo.com/v1/forecast?latitude=${key_lat[$citynumber]}&longitude=${key_long[$citynumber]}&current=temperature_2m&temperature_unit=fahrenheit" | jq '.current.temperature_2m')
echo $temp "°F"
echo -e "\e[38;2;173;255;47m" "done" "\e[0m"
fi
if [[ $found == 0 ]];then
echo "No cities found"
fi
sleep 10



  
  
  