#!/bin/bash

wlan_ac_name='njit_off'
ip_address='0.0.0.0'
mac_address='00:00:00:00:00:00'
username='201234567'
isp='@outnjit'
password='123456'

urlencode(){
    local -a params
    for x in "$@"; do
        params+=("--data-urlencode" "$x")
    done
    curl '' -Gso /dev/null -w %{url_effective} "${params[@]}" | cut -c 3-
}

b64decode(){
    local remainder=$((${#1} % 4))
    local b64string
    if [ $remainder -eq 2 ]; then
        b64string="$1=="
    elif [ $remainder -eq 3 ]; then
        b64string="$1="
    else
        b64string="$1"
    fi
    echo "${b64string}" | tr '_-' '/+' | base64 -d
}

declare -a query=(
    "c=ACSetting"
    "a=Login"
    "protocol=http:"
    "hostname=10.0.1.1"
    "iTermType=1"
    "wlanuserip=${ip_address}"
    "wlanacip=null"
    "wlan_ac_name=${wlan_ac_name}"
    "mac=${mac_address}"
    "ip=${ip_address}"
    "enAdvert=0"
    "queryACIP=0"
    "loginMethod=1"
)

declare -a cookie=(
    "program=123"
    "vlan=0"
    "ip=${ip_address}"
    "ssid=null"
    "areaID=null"
    "ISP_select=${isp}"
    "md5_login2=,0,${username}${isp}|${password}"
)

declare -a post=(
    "DDDDD=,0,${username}${isp}"
    "upass=${password}"
    "R1=0"
    "R2=0"
    "R3=0"
    "R6=0"
    "para=00"
    "0MKKey=123456"
    "buttonClicked="
    "redirect_url="
    "err_flag="
    "username="
    "password="
    "user="
    "cmd="
    "Login="
)

declare request_url="http://10.0.1.1:801/eportal/?"$(urlencode "${query[@]}")
declare cookie_string=$(urlencode "${cookie[@]}" | sed 's/&/; /g')
declare post_data=$(urlencode "${post[@]}")

declare header=$(curl \
    "${request_url}" \
    -X 'POST' \
    -H 'Content-Type: application/x-www-form-urlencoded' \
    -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Trident/7.0; rv:11.0)' \
    -H 'Accept: */*' \
    -H 'Referer: http://10.0.1.1/' \
    -H "Cookie: ${cookie_string}" \
    --data "${post_data}" -sD - -o /dev/null
)

grep '/3.htm' <<< $header > /dev/null && {
    echo "NJIT Login Successful"
    exit 0
} || {
    declare b64msg=$(grep -oE 'ErrorMsg=(\w+)' <<< $header | cut -c10-)
    declare msg=$(b64decode ${b64msg})
    echo "NJIT Login Failed (Reason: ${msg})"
    exit 1
}
