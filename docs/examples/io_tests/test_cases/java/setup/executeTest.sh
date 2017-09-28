#!/bin/bash
############
# Author: TSRK Prasad
# Date: 18-Sep-2016
#
# script fragment used by ../../execute.sh to perform run-time tests. This script is not invoked directly
#
# variables manipulated:
#    TESTMARKS		marks obtained in this test case
#    TIMEDOUT		exit code of timeout utility (124 - timeout, 0 - completed within time)
#
# variabled used:
#	TESTLOG		name of log file that stores results of a test
#	LOG		log file that stores results from all tests
###########

#compilation is successful, now run the test

#get the filename of java class
for file in *.java
do
    [[ -e $file ]] || break
    name="${file%.*}"
    #echo "$name"
done

unset JAVA_TOOL_OPTIONS
CLASSPATH="lib/*:lib/:."		#helps incude jar files and user packages

#syntax: timeout -k soft-limit hard-limit <cmd>
timeout -k 0.5 "$TIMELIMIT" java -cp "$CLASSPATH:." "$name" <input.txt >output.txt | tee "$TESTLOG" > /dev/null
#comment above line and uncomment below line for MAC systems
#gtimeout -k 0.5 $TIMELIMIT java -cp $CLASSPATH:. Driver 2>&1 | tee $TESTLOG > /dev/null

TIMEDOUT="${PIPESTATUS[0]}"
export TIMEDOUT

#import 'dsa_verify' bash function
# shellcheck disable=SC1091
. ../test_cases/dsa.sh

#give marks based on the output matching
TESTMARKS="$(dsa_verify expected_output.txt output.txt)"
export TESTMARKS

#remove score from the run-time log and
# collect the run-time log of this test to overall log.txt
sed '$ d' "$TESTLOG" >> "$LOG"

#empty log file
#truncate -s 0 $TESTLOG		#this line gives problem on MAC machines
rm "$TESTLOG"
touch "$TESTLOG"

#echo "timeOut=$TIMEDOUT"

#references
#	http://stackoverflow.com/questions/1221833/bash-pipe-output-and-capture-exit-status
#	http://unix.stackexchange.com/questions/14270/get-exit-status-of-process-thats-piped-to-another/73180#73180
#	http://stackoverflow.com/questions/4881930/bash-remove-the-last-line-from-a-file
