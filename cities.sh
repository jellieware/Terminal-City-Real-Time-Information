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
  echo $numberofcities ${countries[$numberofcities]} "$cities" 
((numberofcities++))
done
echo "Please choose city:"
read citynumber
echo "-----"
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
echo "Sunrise:"
sunwait list rise $lat $long
echo "Sunset:"
sunwait list sunset $lat $long
echo "TimeZone:"
#cargo build --no-default-features
#cargo add tzf-rs --no-default-features
bodhi=$(tzf --lng ${key_long[$citynumber]} --lat ${key_lat[$citynumber]})
temp="${bodhi#\"}"
result="${temp%\"}"
echo "$result"
echo "Offset:"
mapfile -t other_offset < <(jq --arg oname "$result" -r '.[] | select(.timezone_id == $oname) | .dst_offset' timezonesx.json)
myoffset="${other_offset[@]}"
echo "$myoffset"
echo "Time:"
if [[ $myoffset == -* ]];then
offset=$myoffset
fi
if [[ $myoffset != -* ]];then
offset="$myoffset"
fi
myfinaloffset="$offset"
TZ=UTC date --date="$myfinaloffset hours"
echo "done"
sleep 10



  
  
  