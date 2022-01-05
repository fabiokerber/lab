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
#--name zabbix-web-nginx-mysql -t -e ZBX_SERVER_HOST="zabbix-server-mysql" 
#-e DB_SERVER_HOST="mysql-server" -e MYSQL_DATABASE="zabbixdb" 
#-e MYSQL_USER="zabbix" -e MYSQL_PASSWORD="H9W&n#Iv" 
#-e MYSQL_ROOT_PASSWORD="UCxV*rR&" 
#--network=zabbix-network -p 80:8080 
#--restart unless-stopped -d zabbix/zabbix-web-nginx-mysql:alpine-5.4-latest