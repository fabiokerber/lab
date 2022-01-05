FROM mysql:8.0
#MAINTAINER Zabbix
ENV MYSQL_DATABASE=zabbixdb
ENV MYSQL_USER=zabbix
ENV MYSQL_PASSWORD=H9W&n#Iv
ENV MYSQL_ROOT_PASSWORD=UCxV*rR&
CMD ["--character-set-server=utf8", "--collation-server=utf8_bin", "--default-authentication-plugin=mysql_native_password"]


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
#--name mysql-server -t -e MYSQL_DATABASE="zabbixdb" 
#-e MYSQL_USER="zabbix" -e MYSQL_PASSWORD="H9W&n#Iv" 
#-e MYSQL_ROOT_PASSWORD="UCxV*rR&" --network=zabbix-network 
#-d mysql:8.0 
#--character-set-server=utf8 
#--collation-server=utf8_bin 
#--default-authentication-plugin=mysql_native_password