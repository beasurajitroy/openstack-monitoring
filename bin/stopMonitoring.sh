#!/bin/bash

ps -ef | grep '\-monitoring' | grep -v "grep"| awk '{print $2}'|while read PID;do kill -9 $PID;done
