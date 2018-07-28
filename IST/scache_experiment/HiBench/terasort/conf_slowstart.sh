#!/bin/bash
CONFFILE=/root/hadoop-2.7.5/etc/hadoop/mapred-site.xml
echo "-------------------------------------------------------------------"
echo "|                                                                 |"
echo "|                      SET SLOWSTART : $1                          "
echo "|                                                                 |"
echo "-------------------------------------------------------------------"

sed -i "/mapreduce.job.reduce.slowstart.completedmaps/{n;s/<value>.*<\/value>/<value>$1<\/value>/}" $CONFFILE
