#!/bin/bash

#check that the number of runs has been specified
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <number of dns requests>"
fi

number_of_requests=$1
start_time=`date +"%s"`

for ((i=1; i<=number_of_requests; i++)); do
  dig @20.251.40.206 -p 1053 a ins1.lab.company.com
done

end_time=`date +"%s"`
echo "Start Time    = " $start_time
echo "End Time      = " $end_time
echo "Total Seconds = " $((end_time-start_time))