#!/bin/sh

SETUP=/vagrant/share/setup
HADOOP=hadoop-1.2.1
MODE=$1

echo "[i] Setting up hadoop dependencies"

if [ -z "$MODE" ]; then
	echo "usage: $0 <one-node|cluster>"
fi

## install dependencies
yum -q -y install openssl-devel
yum -q -y install java-1.7.0-openjdk-devel

## install hadoop
export LIB=-lcrypto
curl --silent --output /tmp/hadoop.tar.gz \
  https://archive.apache.org/dist/hadoop/common/${HADOOP}/${HADOOP}.tar.gz
tar -zxf /tmp/hadoop.tar.gz -C /opt
( cd /opt/${HADOOP}/src/c++/utils ; sh configure ; make install )
( cd /opt/${HADOOP}/src/c++/pipes ; sh configure ; make install )
chown -R vagrant /opt/${HADOOP}

mkdir -p /app/hadoop/tmp
chown -R vagrant /app/hadoop/tmp
chmod 750 /app/hadoop/tmp

cp /vagrant/hadoop/${MODE}/* /opt/${HADOOP}/conf/