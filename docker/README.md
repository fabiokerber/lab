# Zabbix #

**Vagrant**

Check https://app.vagrantup.com/boxes/search
    https://app.vagrantup.com/ubuntu/boxes/focal64 (20.04 - focal)


$ docker network create --driver bridge zabbix-network

$ docker run --name mysql-server -t -e MYSQL_DATABASE="zabbix" -e MYSQL_USER="zabbix" -e MYSQL_PASSWORD="zabbix952271" -e MYSQL_ROOT_PASSWORD="root952271" --network=zabbix-network -d mysql:8.0 --restart unless-stopped --character-set-server=utf8 --collation-server=utf8_bin --default-authentication-plugin=mysql_native_password

$ docker run --name zabbix-java-gateway -t --network=zabbix-net --restart unless-stopped -d zabbix/zabbix-java-gateway:alpine-5.4-latest