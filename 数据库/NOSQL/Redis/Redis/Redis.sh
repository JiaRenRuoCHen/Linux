#! /bin/bash
yum -y install gcc
cd redis/
tar -zxf redis-4.0.8.tar.gz
cd redis-4.0.8/
make &&  make install
./utils/install_server.sh
/etc/init.d/redis_6379 status
sed -i 70s/'127.0.0.1'/'192.168.4.57'/ /etc/redis/6379.conf
sed -i 94s/6379/6357/ /etc/redis/6379.conf
/etc/init.d/redis_6379 stop
/etc/init.d/redis_6379 start
netstat -nltup | grep -i redis

