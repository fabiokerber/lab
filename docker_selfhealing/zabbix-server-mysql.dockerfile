#FROM mysql:8.0
##MAINTAINER Zabbix
#ENV MYSQL_DATABASE=zabbixdb
#ENV MYSQL_USER=zabbix
#ENV MYSQL_PASSWORD=H9W&n#Iv
#ENV MYSQL_ROOT_PASSWORD=UCxV*rR&
#RUN npm install 
#ENTRYPOINT ["npm", "start"]
#EXPOSE 3000
#
#FROM nginx:latest
#MAINTAINER Douglas Quintanilha
#COPY /public /var/www/public
#COPY /docker/config/nginx.conf /etc/nginx/nginx.conf
#RUN chmod 755 -R /var/www/public
#EXPOSE 80 443
#ENTRYPOINT ["nginx"]
## Parametros extras para o entrypoint
#CMD ["-g", "daemon off;"]
#
#--name zabbix-server-mysql -t -e DB_SERVER_HOST="mysql-server" 
#-e MYSQL_DATABASE="zabbixdb" -e MYSQL_USER="zabbix" 
#-e MYSQL_PASSWORD="H9W&n#Iv" -e MYSQL_ROOT_PASSWORD="UCxV*rR&" 
#-e ZBX_JAVAGATEWAY="zabbix-java-gateway" 
#--network=zabbix-network -p 10051:10051 
#--restart unless-stopped -d zabbix/zabbix-server-mysql:alpine-5.4-latest