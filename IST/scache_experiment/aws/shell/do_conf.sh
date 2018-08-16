#!/bin/bash
. ./functions.sh

## CONF MASTER
### yarn-site.xml
conf_master_yarn_site() {
	FILE=yarn-site.xml
	KEY=yarn.resourcemanager.scheduler.addres
	VALUE=$MASTER:8030
	conf_hadoop_master $FILE $KEY $VALUE
	
	FILE=yarn-site.xml
	KEY=yarn.resourcemanager.hostname
	VALUE=$MASTER
	conf_hadoop_master $FILE $KEY $VALUE
	
	FILE=yarn-site.xml
	KEY=yarn.resourcemanager.resource-tracker.address
	VALUE=$MASTER:8031
	conf_hadoop_master $FILE $KEY $VALUE
	
	FILE=yarn-site.xml
	KEY=yarn.resourcemanager.address
	VALUE=$MASTER:8032
	conf_hadoop_master $FILE $KEY $VALUE
	
	FILE=yarn-site.xml
	KEY=yarn.resourcemanager.admin.address
	VALUE=$MASTER:8033
	conf_hadoop_master $FILE $KEY $VALUE
	
	FILE=yarn-site.xml
	KEY=yarn.resourcemanager.webapp.address
	VALUE=$MASTER:8088
	conf_hadoop_master $FILE $KEY $VALUE
}
### hdfs-site.xml
conf_master_hdfs_site() {
	FILE=hdfs-site.xml
	KEY=dfs.namenode.http-address
	VALUE=$MASTER:50070
	conf_hadoop_master $FILE $KEY $VALUE
	
	FILE=hdfs-site.xml
        KEY=dfs.namenode.name.dir
        VALUE="\/ebs\/dir\/hadoop\/namenode"
        conf_hadoop_master $FILE $KEY $VALUE	
}
## CONF SLAVES
### yarn-site.xml
conf_slaves_yarn_site() {
	FILE=yarn-site.xml
	KEY=yarn.nodemanager.hostname
	conf_hadoop_slaves_ip $FILE $KEY ""
	
	FILE=yarn-site.xml
	KEY=yarn.nodemanager.localizer.address
	VALUE=":8040"
	conf_hadoop_slaves_ip $FILE $KEY $VALUE
	
	FILE=yarn-site.xml
	KEY=yarn.nodemanager.webapp.address
	VALUE=":8042"
	conf_hadoop_slaves_ip $FILE $KEY $VALUE

	FILE=yarn-site.xml
        KEY=yarn.resourcemanager.resource-tracker.address
        VALUE="${MASTER}:8331"
        conf_hadoop_slaves $FILE $KEY $VALUE
	
	FILE=yarn-site.xml
	KEY=yarn.nodemanager.resource.cpu-vcores
	VALUE="16"
	conf_hadoop_slaves $FILE $KEY $VALUE
	
	FILE=yarn-site.xml
	KEY=yarn.nodemanager.resource.memory-mb
	VALUE="32768"
	conf_hadoop_slaves $FILE $KEY $VALUE
	
	FILE=yarn-site.xml
	KEY=yarn.nodemanager.local-dirs
	VALUE="\\\/ebs\\\/nodemanager\\\/local-dirs"
	conf_hadoop_slaves $FILE $KEY $VALUE
	
	FILE=yarn-site.xml
	KEY=yarn.nodemanager.local-dirs
	VALUE="\\\/ebs\\\/nodemanager\\\/local-dirs"
	conf_hadoop_slaves $FILE $KEY $VALUE
	
	FILE=yarn-site.xml
	KEY=yarn.nodemanager.remote-app-log-dir
	VALUE="\\\/ebs\\\/nodemanager\\\/remote-app-log-dir"
	conf_hadoop_slaves $FILE $KEY $VALUE
}
### hdfs-site.xml
conf_slaves_hdfs_site() {
	FILE=hdfs-site.xml
	KEY=dfs.datanode.data.dir
	VALUE="\\\/ebs\\\/dir\\\/hadoop\\\/datanode"
	conf_hadoop_slaves $FILE $KEY $VALUE
}
### mapred-site.xml
conf_slaves_mapred_site() {
	FILE=mapred-site.xml
	KEY=mapreduce.shuffle.port
	VALUE="13562"
	conf_hadoop_slaves $FILE $KEY $VALUE
	
	FILE=mapred-site.xml
	KEY=mapreduce.cluster.local.dir
	VALUE="\\\/ebs\\\/dir\\\/hadoop\\\//tmp\\\/mapred\\\/local"
	conf_hadoop_slaves $FILE $KEY $VALUE
	
	FILE=mapred-site.xml
	KEY=
	VALUE="\\\/ebs\\\/dir\\\/hadoop\\\/datanode"
	conf_hadoop_slaves $FILE $KEY $VALUE
}
### core-site.xml
conf_slaves_core_site() {
	FILE=core-site.xml
	KEY=fs.defaultFS
	VALUE="hdfs:\\\/\\\/${MASTER}:9000"
	conf_hadoop_slaves $FILE $KEY $VALUE
}

function init() {
	scp_hadoop
	tar_hadoop
	
	mount_disk
	
	conf_master_yarn_site
	conf_master_hdfs_site
	conf_slaves_yarn_site
	conf_slaves_hdfs_site
	conf_slaves_mapred_site
	conf_slaves_core_site
	
	start_yarn
	format_hdfs
	start_hdfs
}

init

#install_java

#scp_origin_jar
#stop_yarn
#start_yarn
#stop_yarn
#stop_hdfs
#format_hdfs
#start_hdfs

#test_slaves


