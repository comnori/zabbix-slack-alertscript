#!/bin/bash

url='https://nas/webapi/entry.cgi?api=SYNO.Chat.External&method=incoming&version=2&token=XXXXXXXXX'

to="$1"
subject="$2"
message="$3"

recoversub='^RECOVER(Y|ED)?$|^OK$|^Resolved.*|^해결.*'
problemsub='^PROBLEM.*|^Problem.*|^발생.*'

if [[ "$subject" =~ $recoversub ]]; then
    emoji=':smile:'
    color='#0C7BDC'
elif [[ "$subject" =~ $problemsub ]]; then
    emoji=':frowning:'
    color='#FFC20A'
else
    emoji=':question:'
    color='#CCCCCC'
fi


payload="payload={\"text\": \"${subject} : ${message} ${emoji}\" }"

return=$(curl -X POST -sm 5 --data-urlencode "$payload" $url)
if [[ "$return" != '{"success":true}' ]]; then
    >&2 echo "$return"
    exit 1
fi
