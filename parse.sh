#!/bin/bash

QUEUE_SIZE=$(curl -s -k http://c05prdapgwisw96.dsi.ad.adp.com:8080/queue/api/json?pretty=true | jq '.items | length')
GET_QUEUE_LIST="http://c05prdapgwisw96.dsi.ad.adp.com:8080/computer/api/xml?tree=computer[executors[currentExecutable[url]],oneOffExecutors[currentExecutable[url]]]&xpath=//url&wrapper=builds"

echo " Build queue is $QUEUE_SIZE"

notify_slack () {

data="Alert : Jenkins Build queue is ${QUEUE_SIZE} http://c05prdapgwisw96.dsi.ad.adp.com:8080/ "

curl -X POST -H 'Content-type: application/json' --data '{"text":"'"$data"'"}' https://hooks.slack.com/services/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

}

stop_struck_job () {

wget -O running_jobs.xml $GET_QUEUE_LIST
cat running_jobs.xml | xmllint --format - > running_jobs_list.xml

// stop only first 6 queued jobs
stop_count=0
while read line;do
    	url=$(echo $line | sed 's/<.*>\(.*\)<\/.*>/\1/g')
    	if [[ $url == http* ]] ;
        	then
            	curl -X POST "$url"stop
                ++stop_count
    	fi
        if [[ "$stop_count" -eq 6 ]]; then
            break
        fi
	done <running_jobs_list.xml

}

if [[ $QUEUE_SIZE -gt 15 ]]
then
   notify_slack
   stop_struck_job
   
fi

