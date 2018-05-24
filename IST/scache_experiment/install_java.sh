#!/bin/bash
apt-get update
apt-get install -y default-jre
JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> /etc/profile
source /etc/profile

