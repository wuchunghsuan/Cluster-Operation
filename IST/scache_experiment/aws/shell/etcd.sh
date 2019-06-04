#!/bin/bash
REGISTRY=quay.io/coreos/etcd

ETCD_VERSION=latest
TOKEN=incongruous
CLUSTER_STATE=new
NAME_1=ip-172-31-16-183.cn-northwest-1.compute.internal
NAME_2=ip-172-31-19-23.cn-northwest-1.compute.internal
NAME_3=ip-172-31-19-244.cn-northwest-1.compute.internal
NAME_4=ip-172-31-20-16.cn-northwest-1.compute.internal
NAME_5=ip-172-31-20-200.cn-northwest-1.compute.internal
NAME_6=ip-172-31-20-244.cn-northwest-1.compute.internal
NAME_7=ip-172-31-20-75.cn-northwest-1.compute.internal
NAME_8=ip-172-31-20-93.cn-northwest-1.compute.internal
HOST_1=172.31.16.183
HOST_2=172.31.19.23
HOST_3=172.31.19.244
HOST_4=172.31.20.16
HOST_5=172.31.20.200
HOST_6=172.31.20.244
HOST_7=172.31.20.75
HOST_8=172.31.20.93
CLUSTER=${NAME_1}=http://${HOST_1}:2380,${NAME_2}=http://${HOST_2}:2380,${NAME_3}=http://${HOST_3}:2380,${NAME_4}=http://${HOST_4}:2380,${NAME_5}=http://${HOST_5}:2380,${NAME_6}=http://${HOST_6}:2380,${NAME_7}=http://${HOST_7}:2380,${NAME_0}=http://${HOST_0}:2380

DATA_DIR=/home/wuchunghsuan/etcd

THIS_NAME=${NAME_0}
THIS_IP=${HOST_0}
docker run \
  -p 2379:2379 \
  -p 2380:2380 \
  -d \
  --net=host \
  --volume=${DATA_DIR}:/etcd-data \
  --name etcd ${REGISTRY}:${ETCD_VERSION} \
  /usr/local/bin/etcd \
  --data-dir=/etcd-data --name ${THIS_NAME} \
  --initial-advertise-peer-urls http://${THIS_IP}:2380 --listen-peer-urls http://0.0.0.0:2380 \
  --advertise-client-urls http://${THIS_IP}:2379 --listen-client-urls http://0.0.0.0:2379 \
  --initial-cluster ${CLUSTER} \
  --initial-cluster-state ${CLUSTER_STATE} --initial-cluster-token ${TOKEN}
