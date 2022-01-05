FROM zabbix-java-gateway:alpine-5.4-latest
ENV MYSQL_DATABASE=zabbixdb
ENV MYSQL_USER=zabbix
ENV MYSQL_PASSWORD=H9W&n#Iv
ENV MYSQL_ROOT_PASSWORD=UCxV*rR&
CMD ["--character-set-server=utf8", "--collation-server=utf8_bin", "--default-authentication-plugin=mysql_native_password"]

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
#--name zabbix-java-gateway -t --network=zabbix-network 
#--restart unless-stopped -d zabbix/zabbix-java-gateway:alpine-5.4-latest



