#!/bin/bash
# Script para verificar status do servidor
# Criado por Aécio Oliveira
# VERSION 1.1 Aécio Oliveira
# VERSION 1.2 Aécio Oliveira (alteração na criação dos logs, devido a necessidade de termos um log, para banco, backup externo, backup online e status dos servidores).
########################################################################################################################
##########################Variaveis Fixa################################################################################
ano=$(date +%y)                         		# Atribui o ano atual a variavel ano.
mes=$(date +%m)                         		# Atribui o mes atual a variavel mes.
dia=$(date +%d)                         		# Atribui o dia atual a variavel dia.
diadasemana=$(date +%A)                 		# Atribui o dia atual a variavel dia.
ipwan=$(wget -q -O - http://whatismyip.akamai.com/) 	# Atribui o IP
datastatus=`date +%a-%d-%m-%Y-%H:%M`                	# Status da Data
dia_semana=$(date +A)                   		# Atribui o dia da semana.
/bin/touch /var/log/argon/status_servidor/status_servidor_$dia-$mes-$ano.log  # Cria o Log
SYNC_LOG=/var/log/argon/status_servidor/status_servidor_$dia-$mes-$ano.log    # Local armazenamento do log
databkp=`date +%a-%d-%m-%Y-%H:%M`       		# Data do Backup
DATA=$dia-$mes-$ano					# Data completa
STATUSOK=OK						# Status ok
STATUSERRO=ERRO						# Status erro
########################################################################################################################
#############################################Variaveis Declaradas#######################################################
SERVIDOR=SRV02						#NOME DO SERVIDOR
CLIENTE=LAPA						#NOME DO NOSSO CLIENTE
DRBD0=/work0/						#DISCO DRBD0		
DRBD1=/work1/						#DISCO DRBD1
DRBD2=/work2/						#DISCO DRBD2
#DRBD3=/home/usuario/programas/				#DISCO DRBD3
TAREFA=STATUS-$SERVIDOR					#TAREFA
EMAILCOPIA0=infraestrutura@argoninformatica.com.br	#EMAIL EM COPIA 0
EMAILCOPIA1=						#EMAIL EM COPIA 1
EMAILCOPIA2=						#EMAIL EM COPIA 2
EMAILCOPIA3=						#EMAIL EM COPIA 3
########################################################################################################################
#######################################STATUS_LOG#######################################################################
echo "######################################Status do Cliente######################################" >> $SYNC_LOG
echo " " >> $SYNC_LOG
echo "##############################################################################################" >> $SYNC_LOG
echo "Cliente= $CLIENTE - STATUS $SERVIDOR" >> $SYNC_LOG
echo "IP= $ipwan" >> $SYNC_LOG
echo "Servidor: $(uname -a)" >> $SYNC_LOG
echo "Uptime: $(uptime)" >> $SYNC_LOG
echo "Data: $datastatus" >> $SYNC_LOG
echo " " >> $SYNC_LOG
########################################################################################################################
########################################################################################################################
echo "##############################################################################################" >> $SYNC_LOG
echo " " >> $SYNC_LOG
echo "#############################Estado dos discos################################################" >> $SYNC_LOG
echo " " >>$SYNC_LOG
df -h >> $SYNC_LOG
echo " " >> $SYNC_LOG
echo "##############################################################################################" >> $SYNC_LOG
echo " " >> $SYNC_LOG
du -h --max-depth=1 $DRBD00>> $SYNC_LOG
echo " " >> $SYNC_LOG
echo "##############################################################################################" >> $SYNC_LOG
echo " " >> $SYNC_LOG
du -h --max-depth=1 $DRBD1 >> $SYNC_LOG
echo " " >> $SYNC_LOG
echo "##############################################################################################" >> $SYNC_LOG
echo " " >> $SYNC_LOG
du -h --max-depth=1 $DRBD2 >> $SYNC_LOG
echo " " >> $SYNC_LOG
echo "##############################################################################################" >> $SYNC_LOG
echo " " >> $SYNC_LOG
du -h --max-depth=1 $DRBD3 >> $SYNC_LOG
echo " " >> $SYNC_LOG
echo "##############################################################################################" >> $SYNC_LOG
echo " " >> $SYNC_LOG
echo "##############################################################################################" >> $SYNC_LOG
echo "- Memoria RAM e Swap" >> $SYNC_LOG
echo " " >> $SYNC_LOG
free >> $SYNC_LOG
echo " " >> $SYNC_LOG
echo "##############################################################################################" >> $SYNC_LOG
echo "Alta Disponibilidade" >> $SYNC_LOG
echo "." >> $SYNC_LOG
echo "a)Servico de Replicacao........................................" >> $SYNC_LOG
echo "." >> $SYNC_LOG
/etc/init.d/drbd status >> $SYNC_LOG
echo " " >> $SYNC_LOG
echo "b)Servico de Controle Principal/Reserva........................" >> $SYNC_LOG
echo " " >> $SYNC_LOG
echo "##############################################################################################" >> $SYNC_LOG
echo "HeartBeat" >> $SYNC_LOG
/etc/init.d/heartbeat status >> $SYNC_LOG
echo " " >> $SYNC_LOG
echo "##############################################################################################" >> $SYNC_LOG
echo "- Estado do Servidor SMB" >> $SYNC_LOG
echo " " >> $SYNC_LOG
/etc/init.d/samba status >> $SYNC_LOG
echo " " >> $SYNC_LOG
echo "##############################################################################################" >> $SYNC_LOG
echo "- Estado do Servidor DHCP" >> $SYNC_LOG
echo " " >> $SYNC_LOG
/etc/init.d/dhcpd status >> $SYNC_LOG
echo " " >> $SYNC_LOG
echo "##############################################################################################" >> $SYNC_LOG
echo "- Estado do Servidor Postgres" >> $SYNC_LOG
echo " " >> $SYNC_LOG
/etc/init.d/postgres status >> $SYNC_LOG
echo " " >> $SYNC_LOG
echo "##############################################################################################" >> $SYNC_LOG
echo "- Estado do Payara" >> $SYNC_LOG
echo " " >> $SYNC_LOG
/etc/init.d/payara status >> $SYNC_LOG
echo " " >> $SYNC_LOG
echo "##############################################################################################" >> $SYNC_LOG
echo "- Usuarios logados" >> $SYNC_LOG
echo " " >> $SYNC_LOG
smbstatus >> $SYNC_LOG
echo " " >> $SYNC_LOG
echo "##############################################################################################" >> $SYNC_LOG
echo "- Mensagens do Kernel" >> $SYNC_LOG
echo " " >> $SYNC_LOG
cat /var/log/messages | grep kernel >> $SYNC_LOG
echo " " >> $SYNC_LOG
echo "##############################################################################################" >> $SYNC_LOG
echo "- Mensagens de Erro" >> $SYNC_LOG
echo " " >> $SYNC_LOG
cat /var/log/messages | grep erro >> $SYNC_LOG
echo " " >> $SYNC_LOG
echo "##############################################################################################" >> $SYNC_LOG
echo "- Mensagens do SMART" >> $SYNC_LOG
echo " " >> $SYNC_LOG
cat /var/log/messages | grep smart >> $SYNC_LOG
echo " " >> $SYNC_LOG
echo "##############################################################################################" >> $SYNC_LOG
echo "- Mensagens do SMBD" >> $SYNC_LOG
echo " " >> $SYNC_LOG
tail -100 /var/log/samba/smbd.log >> $SYNC_LOG
echo " " >> $SYNC_LOG
echo "##############################################################################################" >> $SYNC_LOG
echo "- Mensagens do Audit - arquivos apagados" >> $SYNC_LOG
echo " " >> $SYNC_LOG
tail -100 /var/log/samba/samba-full_audit.log | grep unlink >> $SYNC_LOG
echo " " >> $SYNC_LOG
echo "###############################FIM###########################################################" >> $SYNC_LOG

unix2dos $SYNC_LOG

/sbin/sendEmail -f bkpargon@gmail.com -t bkpargon@gmail.com -u $TAREFA $CLIENTE $DATA $STATUSOK -a $SYNC_LOG -m $TAREFA $CLIENTE $DATA $STATUSOK -o tls=yes -s smtp.googlemail.com:587 -xu bkpargon@gmail.com -xp argon1935 -cc $EMAILCOPIA0 -cc $EMAILCOPIA1 -cc $EMAILCOPIA2 -cc $EMAILCOPIA3

exit 0
