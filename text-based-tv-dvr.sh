#!/bin/bash

record_jobs="/apollo-usbshare/tv-dvr/record-jobs.txt"
record_loc="/apollo-usbshare/tv-dvr/recordings"

################### JOBS FILE (record_jobs) LINE ENTRIES FORMAT ######################
# MM-DD-YYYY-HH-MM MMm ChannelNo.X FileName EOL
# 12-21-2021-20-00 120m 10.1 DecemberVideo EOL
######################################################################################

while IFS= read -r line
do
        start_time=$(echo $line | awk '{print $1}')
        duration=$(echo $line | awk '{print $2}')
        channel=$(echo $line | awk '{print $3}')
        file_name=$(echo $line | awk '{print $4}')

        echo LINE : $start_time $duration $channel $file_name

        now_time=$(date +%m-%d-%Y-%H-%M)

        echo TIME : $now_time

        if  [ $now_time = $start_time ]; then
                echo "$now_time : Starting recording for $duration on channel $channel to $file_name"
                video_file="$record_loc/$start_time--$duration--$channel--$file_name.mp4"
                log_file="$log_loc/$start_time--$duration--$channel--$file_name.job"
                /usr/bin/timeout $duration /usr/bin/wget http://<Your_HDHomeRun_IPAddress>:5004/auto/v$channel -O $video_file &
        fi
done < $record_jobs
