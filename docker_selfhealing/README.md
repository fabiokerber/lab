# Zabbix #

**Vagrant + Docker**

Check https://app.vagrantup.com/boxes/search<br>
    https://app.vagrantup.com/ubuntu/boxes/focal64 (20.04 - focal)

```
> vagrant up
> vagrant ssh zabbix_srv

---
$ docker stop $(docker ps -q)
$ docker container prune
$ docker exec -it <container name> /bin/bash
https://www.youtube.com/watch?v=ScKlF0ICVYA&t=957s
https://hub.docker.com/r/zabbix/zabbix-agent
---

$ sudo usermod -aG docker $(whoami)
$ exit

> vagrant ssh zabbix_srv

$ docker version
```

**Zabbix (docker run)**

```
$ docker network create --driver bridge --subnet 172.20.0.0/16 --ip-range 172.20.240.0/20 zabbix-network

$ docker run --name mysql-server -t -e MYSQL_DATABASE="zabbixdb" -e MYSQL_USER="zabbix" -e MYSQL_PASSWORD="H9W&n#Iv" -e MYSQL_ROOT_PASSWORD="UCxV*rR&" --network=zabbix-network -d mysql:8.0 --character-set-server=utf8 --collation-server=utf8_bin --default-authentication-plugin=mysql_native_password

$ docker run --name zabbix-java-gateway -t --network=zabbix-network --restart unless-stopped -d zabbix/zabbix-java-gateway:alpine-5.4-latest

$ docker run --name zabbix-server-mysql -t -e DB_SERVER_HOST="mysql-server" -e MYSQL_DATABASE="zabbixdb" -e MYSQL_USER="zabbix" -e MYSQL_PASSWORD="H9W&n#Iv" -e MYSQL_ROOT_PASSWORD="UCxV*rR&" -e ZBX_JAVAGATEWAY="zabbix-java-gateway" --network=zabbix-network -p 10051:10051 --restart unless-stopped -d zabbix/zabbix-server-mysql:alpine-5.4-latest

$ docker run --name zabbix-web-nginx-mysql -t -e ZBX_SERVER_HOST="zabbix-server-mysql" -e DB_SERVER_HOST="mysql-server" -e MYSQL_DATABASE="zabbixdb" -e MYSQL_USER="zabbix" -e MYSQL_PASSWORD="H9W&n#Iv" -e MYSQL_ROOT_PASSWORD="UCxV*rR&" --network=zabbix-network -p 80:8080 --restart unless-stopped -d zabbix/zabbix-web-nginx-mysql:alpine-5.4-latest

$ docker run --name zabbix-agent -e ZBX_HOSTNAME="Zabbix server" -e ZBX_SERVER_HOST="172.20.240.3" -e ZBX_LISTENPORT=10050 --network=zabbix-network -p 10050:10050 -d zabbix/zabbix-agent:alpine-5.4-latest
```

**Zabbix (docker run)**

```
$ docker-compose build

$ docker-compose up -d
```

http://IP<br>
    Admin<br>
    zabbix

**AWX**