apt-get install apt-transport-https ca-certificates && \
apt-key adv --keyserver-options http-proxy=http://myproxy.com:10 \
               --keyserver hkp://ha.pool.sks-keyservers.net:80 \
               --recv-keys 58118E89F3A912897C070ADBF76221572C52609D && \
echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" | sudo tee /etc/apt/sources.list.d/docker.list && \
apt-get update -y && \
apt-get install -y docker-engine
