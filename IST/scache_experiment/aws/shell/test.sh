#!/bin/bash
. ./functions.sh

## CONF MASTER
### yarn-site.xml
conf_master_yarn_site() {
	FILE=yarn-site.xml
	KEY=yarn.resourcemanager.scheduler.addres
	VALUE=192.168.2.11:8130
	conf_hadoop_master $FILE $KEY $VALUE
	
	FILE=yarn-site.xml
	KEY=yarn.resourcemanager.resource-tracker.address
	VALUE=192.168.2.11:8131
	conf_hadoop_master $FILE $KEY $VALUE
	
	FILE=yarn-site.xml
	KEY=yarn.resourcemanager.address
	VALUE=192.168.2.11:8132
	conf_hadoop_master $FILE $KEY $VALUE
	
	FILE=yarn-site.xml
	KEY=yarn.resourcemanager.admin.address
	VALUE=192.168.2.11:8133
	conf_hadoop_master $FILE $KEY $VALUE
	
	FILE=yarn-site.xml
	KEY=yarn.resourcemanager.webapp.address
	VALUE=192.168.2.11:8088
	conf_hadoop_master $FILE $KEY $VALUE
}
### hdfs-site.xml
conf_master_hdfs_site() {
	FILE=hdfs-site.xml
	KEY=dfs.namenode.http-address
	VALUE=192.168.2.11:50070
	conf_hadoop_master $FILE $KEY $VALUE
	
	FILE=hdfs-site.xml
        KEY=dfs.namenode.name.dir
        VALUE="\/root\/dir\/hadoop\/namenode"
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
	VALUE=":8140"
	conf_hadoop_slaves_ip $FILE $KEY $VALUE
	
	FILE=yarn-site.xml
	KEY=yarn.nodemanager.webapp.address
	VALUE=":8142"
	conf_hadoop_slaves_ip $FILE $KEY $VALUE

	FILE=yarn-site.xml
        KEY=yarn.resourcemanager.resource-tracker.address
        VALUE="${MASTER}:8131"
        conf_hadoop_slaves $FILE $KEY $VALUE
}
### hdfs-site.xml
conf_slaves_hdfs_site() {
	FILE=hdfs-site.xml
	KEY=dfs.datanode.data.dir
	VALUE="\\\/root\\\/dir\\\/hadoop\\\/datanode"
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
	VALUE="\\\/root\\\/dir\\\/hadoop\\\//tmp\\\/mapred\\\/local"
	conf_hadoop_slaves $FILE $KEY $VALUE
	
	FILE=mapred-site.xml
	KEY=
	VALUE="\\\/root\\\/dir\\\/hadoop\\\/datanode"
	conf_hadoop_slaves $FILE $KEY $VALUE
}
### core-site.xml
conf_slaves_core_site() {
	FILE=core-site.xml
	KEY=fs.defaultFS
	VALUE="hdfs:\\\/\\\/${MASTER}:9000"
	conf_hadoop_slaves $FILE $KEY $VALUE
}

#scp_hadoop
#tar_hadoop

#conf_master_yarn_site
#conf_master_hdfs_site
#conf_slaves_yarn_site
#conf_slaves_hdfs_site
#conf_slaves_mapred_site
conf_slaves_core_site

#install_java
#stop_yarn
#start_yarn
#stop_yarn
#stop_hdfs
#format_hdfs
#start_hdfs




