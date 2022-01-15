Pré requisito:

|Tool    |Link|
|-------------|-----------|
|`Vagrant`| https://releases.hashicorp.com/vagrant/2.2.19/vagrant_2.2.19_x86_64.msi
|`VirtualBox`| https://download.virtualbox.org/virtualbox/6.1.30/VirtualBox-6.1.30-148432-Win.exe
|`Postman`| https://www.postman.com/downloads/

# Zabbix & AWX #

**Zabbix (docker run)**

```
$ docker network create --driver bridge zabbix-network
$ docker run --name mysql-server -t -e MYSQL_DATABASE="zabbixdb" -e MYSQL_USER="zabbix" -e MYSQL_PASSWORD="H9W&n#Iv" -e MYSQL_ROOT_PASSWORD="UCxV*rR&" --network=zabbix-network -d mysql:8.0 --character-set-server=utf8 --collation-server=utf8_bin --default-authentication-plugin=mysql_native_password
$ docker run --name zabbix-java-gateway -t --network=zabbix-network --restart unless-stopped -d zabbix/zabbix-java-gateway:alpine-5.4-latest
$ docker run --name zabbix-server-mysql -t -e DB_SERVER_HOST="mysql-server" -e MYSQL_DATABASE="zabbixdb" -e MYSQL_USER="zabbix" -e MYSQL_PASSWORD="H9W&n#Iv" -e MYSQL_ROOT_PASSWORD="UCxV*rR&" -e ZBX_JAVAGATEWAY="zabbix-java-gateway" --network=zabbix-network -p 10051:10051 --restart unless-stopped -d zabbix/zabbix-server-mysql:alpine-5.4-latest
$ docker run --name zabbix-web-nginx-mysql -t -e ZBX_SERVER_HOST="zabbix-server-mysql" -e DB_SERVER_HOST="mysql-server" -e MYSQL_DATABASE="zabbixdb" -e MYSQL_USER="zabbix" -e MYSQL_PASSWORD="H9W&n#Iv" -e MYSQL_ROOT_PASSWORD="UCxV*rR&" --network=zabbix-network -p 80:8080 --restart unless-stopped -d zabbix/zabbix-web-nginx-mysql:alpine-5.4-latest
$ docker run --name zabbix-agent -e ZBX_HOSTNAME="Zabbix server" -e ZBX_SERVER_HOST="172.20.240.3" -e ZBX_LISTENPORT=10050 --network=zabbix-network -p 10050:10050 -d zabbix/zabbix-agent:alpine-5.4-latest
```


**Zabbix (docker compose)**

```
$ docker-compose build
$ docker-compose --profile zabbix up -d
$ watch docker ps
```

**Vagrant**
```
!!! Edit Vagrantfile !!!
    ## SETAR IP'S
    ZABBIX_IP = '192.168.0.50'
    AWX_IP = '192.168.0.100'
    CENTOS_SRV01 = '192.168.0.150'
    INTERFACE_LAN = 'TP-Link Wireless MU-MIMO USB Adapter'

**- ZABBIX -**

> vagrant up zabbix_srv

http://ZABBIX_IP<br>
    Admin<br>
    zabbix


**- AWX -**

> vagrant up awx_srv
> vagrant ssh awx_srv -c 'cat /tmp/awx-17.1.0/installer/inventory | grep admin_password' (anotar!)
> vagrant ssh awx_srv -c 'sudo tower-cli config | grep password' (anotar!)
> vagrant ssh awx_srv
    $ curl -X POST -k -H "Content-type: application/json" -d '{"description":"Personal Tower CLI token", "application":null, "scope":"write"}' http://admin:<admin_password>@192.168.0.100/api/v2/users/1/personal_tokens/ | python3 -m json.tool (Get Token)

http://AWX_IP<br>
    admin<br>
    "admin_password"
---

**AWX cli**

> vagrant ssh awx_srv
    $ tower-cli config

!!! Verificar possibilidade de montar essa pasta em um disco adicional !!!
    zabbix_srv.vm.provision 'shell', inline: 'sudo mkdir /zabbixdb'

$ docker stop $(docker ps -q)
$ docker container prune
$ docker exec -it <container name> /bin/bash
https://www.youtube.com/watch?v=ScKlF0ICVYA&t=957s
https://hub.docker.com/r/zabbix/zabbix-agent
---
```

**AWX**

. Criar organizacao (Lab)<br>
. Criar credencial u: awx | p: awx_pass (Lab - Machine - Privilege Escalation Method: sudo - Privilege Escalation Password: awx_pass)<br>
. Criar inventario (Instance Groups: tower - Organization: Lab)<br>
. Criar host (192.168.0.150 | centos-srv01 > DNS host AWX_SRV)<br>
. Criar projeto a(Update System - Privilege Escalation: On)<br>
. Criar projeto b(Install NGINX - Privilege Escalation: On)<br>
. Criar template a<br>
. Criar template b(Survey: On - Answer variable name: host_name - Maximum length: 20)<br>

**POSTMAN - GET - Info execução template 9 "Update System".**<br>
http://192.168.0.100/api/v2/job_templates/9/<br>
<kbd>
    <img src="https://github.com/fabiokerber/lab/blob/main/images/150120221604.jpg">
</kbd>
<br />
<br />

**POSTMAN - POST - Acionamento template 9 "Update System".**<br>
http://192.168.0.100/api/v2/job_templates/9/launch/<br>
<kbd>
    <img src="https://github.com/fabiokerber/lab/blob/main/images/150120221612.jpg">
</kbd>
<br />
<br />

**POSTMAN - POST - Acionamento template 9 "Update System".**<br>
http://192.168.0.100/api/v2/job_templates/11/launch/<br>
```
{       "extra_vars":   {
            "host_name": "centos_srv01"
                        }
}
```
<kbd>
    <img src="https://github.com/fabiokerber/lab/blob/main/images/150120221639.jpg">
    <img src="https://github.com/fabiokerber/lab/blob/main/images/150120221641.jpg">
</kbd>
<br />
<br />