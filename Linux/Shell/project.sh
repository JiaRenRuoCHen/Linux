#!/bin/bash
yum -y install gcc pcre-devel openssl-devel > /dev/null
tar -zxf lnmp_soft.tar.gz
tar -zxf lnmp_soft/nginx-1.12.2.tar.gz
cd nginx-1.12.2/
useradd -s /sbin/nologin nginx
./configure --user=nginx --group=nginx --with-http_ssl_module --with-http_stub_status_module > /dev/null
make > /dev/null
make install > /dev/null
echo "安装nginx成功"
sed -i '65,71s/#//' /usr/local/nginx/conf/nginx.conf
sed -i '/SCRIPT_FILENAME/d' /usr/local/nginx/conf/nginx.conf
sed -i 's/fastcgi_params/fastcgi.conf/' /usr/local/nginx/conf/nginx.conf
sed -i '45s/index.html/index.php index.html/' /usr/local/nginx/conf/nginx.conf
yum -y install mariadb mariadb-server mariadb-devel > /dev/null
yum -y install php php-fpm php-mysql > /dev/null
echo '[Unit]
Description=The Nginx HTTP Server
After=network.target remote-fs.target nss-lookup.target
[Service]
Type=forking
ExecStart=/usr/local/nginx/sbin/nginx
ExecReload=/usr/local/nginx/sbin/nginx -s reload
ExecStop=/bin/kill -s QUIT ${MAINPID}
[Install]
WantedBy=multi-user.target' > /usr/lib/systemd/system/nginx.service
systemctl start mariadb php-fpm nginx 
systemctl enable mariadb php-fpm nginx > /dev/null
mysql -e "create database wordpress character set utf8mb4;"
mysql -e "grant all on wordpress.* to wordpress@'localhost' identified by 'wordpress';"
mysql -e "grant all on wordpress.* to wordpress@'192.168.2.11' identified by 'wordpress';"
mysql -e "flush privileges;"
echo "安装mariadb成功"
echo "安装lnmp环境成功"
cd
yum -y install unzip > /dev/null
unzip lnmp_soft/wordpress.zip > /dev/null
cd wordpress
tar -xf wordpress-5.0.3-zh_CN.tar.gz
cp -r wordpress/* /usr/local/nginx/html/
chown -R apache:apache /usr/local/nginx/html/
cd



