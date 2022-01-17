Pré requisitos:

|Tool|Link\Command|
|-------------|-----------|
|`Vagrant`| https://releases.hashicorp.com/vagrant/2.2.19/vagrant_2.2.19_x86_64.msi
|`Install Vagrant Env Plugin`| vagrant plugin install vagrant-env
|`VirtualBox`| https://download.virtualbox.org/virtualbox/6.1.30/VirtualBox-6.1.30-148432-Win.exe
|`Postman`| https://www.postman.com/downloads/

|Tool|Version|
|-------------|-----------|
|`Docker`| v20.10.12
|`Docker-Compose`| v1.29.2
|`AWX`| v17.1.0
|`Zabbix`| v5.4

|VM|Requirement|
|-------------|-----------|
|`Zabbix`| 4vCPU 4GB
|`AWX`| 4vCPU 8GB
|`Centos SRV01`| 2vCPU 1GB

# Vagrant #
```
!!! Edit Vagrantfile !!!
    centos_srv01.vm.provision 'shell', inline: 'sudo sed -i "s|Server=127.0.0.1|Server=192.168.0.50|g" /etc/zabbix/zabbix_agentd.conf'

!!! Edit .env !!!
    TAG='5.2' (tag zabbix)
    ZABBIX_IP='192.168.0.50'
    AWX_IP='192.168.0.100'
    CENTOS_SRV01='192.168.0.150'
    INTERFACE_LAN='TP-Link Wireless MU-MIMO USB Adapter'

    Obs: .env = Variáveis para docker-compose.yml e Vagrantfile
         dockerfile/*.dockerfile = Necessário alterar tag manualmente


--- ZABBIX ---

> vagrant up zabbix_srv

http://ZABBIX_IP:8080
    Admin
    zabbix


--- AWX ---

> vagrant up awx_srv
> vagrant ssh awx_srv -c 'cat /tmp/awx-17.1.0/installer/inventory | grep admin_password' (anotar!)
> vagrant ssh awx_srv -c 'sudo tower-cli config | grep password' (anotar!)
> vagrant ssh awx_srv
    $ curl -X POST -k -H "Content-type: application/json" -d '{"description":"Personal Tower CLI token", "application":null, "scope":"write"}' http://admin:<admin_password>@192.168.0.100/api/v2/users/1/personal_tokens/ | python3 -m json.tool (Get Token)

http://AWX_IP
    admin
    "admin_password"


--- CENTOS SRV01 ---

> vagrant up centos_srv01
```

# ZABBIX #

. Configurar TimeZone Administration > General > GUI<br>
. Configurar TimeZone User Settings > Profile<br>
. Zabbix Server > Remover template Zabbix Agent > Unlink and Clear<br>
. Importar zbx_templates<br>
. Aplicar novos templates aos hosts<br>

# AWX #

. Criar organizacao **(Lab)**<br>
. Criar credencial u: awx | p: awx_pass **(Lab - Machine - Privilege Escalation Method: sudo - Privilege Escalation Password: awx_pass)**<br>
. Criar inventario **Server Linux - Organization: Lab - Instance Groups: tower)**<br>
. Criar host **(192.168.0.150 | centos-srv01 > DNS host AWX_SRV)**<br>
. Criar projeto a **(Update System - Privilege Escalation: On)**<br>
. Criar projeto b **(Install NGINX - Privilege Escalation: On)**<br>
. Criar template a **(Variables: Prompt on launch - Limit: Prompt on launch)**<br>
. Criar template b **(Variables: Prompt on launch - Limit: Prompt on launch)**<br>

**POSTMAN - GET - Info execução template 9 "Update System".**
```
http://192.168.0.100/api/v2/job_templates/9/
admin
<admin_password>
```
<kbd>
    <img src="https://github.com/fabiokerber/lab/blob/main/images/150120221604.jpg">
</kbd>
<br />
<br />

**POSTMAN - POST - Acionamento template 9 "Update System".**
```
http://192.168.0.100/api/v2/job_templates/9/launch/
admin
<admin_password>
```
<kbd>
    <img src="https://github.com/fabiokerber/lab/blob/main/images/150120221612.jpg">
</kbd>
<br />
<br />

**POSTMAN - POST - Acionamento template 11 com Extra Vars "Install NGINX".**
```
http://192.168.0.100/api/v2/job_templates/11/launch/
admin
<admin_password>

{
    "extra_vars": {
        "hostname": "centos_srv01"
    }
}
```
<kbd>
    <img src="https://github.com/fabiokerber/lab/blob/main/images/150120221639.jpg">
</kbd>
<kbd>
    <img src="https://github.com/fabiokerber/lab/blob/main/images/150120221641.jpg">
</kbd>
<br />
<br />

**POSTMAN - POST - Acionamento template 11 sem Extra Vars "Install NGINX".**<br>
Obs: Não houve acionamento no AWX.<br>
```
http://192.168.0.100/api/v2/job_templates/11/launch/
admin
<admin_password>
```
<kbd>
    <img src="https://github.com/fabiokerber/lab/blob/main/images/150120221651.jpg">
</kbd>
<br />
<br />

**Curl - POST - Acionamento templates 9 e 11 (com Extra Vars), via centos-srv01.**<br>
```
https://adam.younglogic.com/2018/08/job-tower-rest/ (fonte)
https://github.com/ansible/ansible/issues/37702 (fonte)

> vagrant ssh centos_srv01
    $ curl -H "Content-Type: application/json" -X POST -s -u admin:madoov4T -k http://192.168.0.100/api/v2/job_templates/9/launch/ | jq '.url'
    $ curl -H "Content-Type: application/json" -X POST -s -u admin:ei4meiZo -d '{ "limit": "192.168.0.150", "extra_vars": { "service": "nginx" }}' -k http://192.168.0.100/api/v2/job_templates/10/launch/ | jq '.url' (limit e extra vars)
```

# Backup #

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


**AWX cli**
```
> vagrant ssh awx_srv
    $ tower-cli config
```
```
!!! Verificar possibilidade de montar essa pasta em um disco adicional !!!
    zabbix_srv.vm.provision 'shell', inline: 'sudo mkdir /zabbixdb'

$ docker stop $(docker ps -q)
$ docker container prune
$ docker exec -it <container name> /bin/bash
> vagrant ssh zabbix_srv -c 'sudo docker ps'
> vagrant ssh zabbix_srv -c 'sudo docker-compose -f /vagrant/docker-compose.yml --profile zabbix up -d'
https://www.youtube.com/watch?v=ScKlF0ICVYA&t=957s
https://hub.docker.com/r/zabbix/zabbix-agent
```

**Docker Hub - Zabbix**

https://hub.docker.com/r/zabbix/zabbix-java-gateway<br>
https://hub.docker.com/r/zabbix/zabbix-server-mysql<br>
https://hub.docker.com/r/zabbix/zabbix-web-nginx-mysql<br>