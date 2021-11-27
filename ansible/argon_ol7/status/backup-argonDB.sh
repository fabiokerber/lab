#!/bin/bash
# Script para realizacao de backup da base de dados da argon
# Criado por Aécio Oliveira
#VERSION 1.1
. /etc/profile
DATAFEITO="`date +%A`"						# Atribui a data ao Backup
PGPASSWORD="s3nh2"						#	
export PGPASSWORD						
ano=$(date +%y)                         			# Atribui o ano atual a variavel ano.
mes=$(date +%m)                         			# Atribui o mes atual a variavel mes.
dia=$(date +%d)                         			# Atribui o dia atual a variavel dia.
DATA=$dia-$mes-$ano						# Atribui a data antes do envio do email
STATUSOK=OK							# Status de ok anexo ao email
STATUSERRO=ERRO							# Status de erro anexo ao email
########################################################################################################################
######Estas variaveis abaixo devem ser alimentadas de acordo com a informação dos Nossos Clientes#######################
########################################################################################################################
CLIENTE=PENHA							# Nome do Cliente	
EXECUTAVEL=/work0/argon-infra/pgsql/bin				# Diretorio do Executavel do Postgres
IP_HOST=127.0.0.1						# IP do Servidor
PORT=5432							# Porta do Servidor
USER=argon							# Usuario do Banco	
DIRECTORY_SAVE=/backupDB/backupHDI/backup-argonDB/argonDB_dia_$DATAFEITO.backup #Diretorio onde sera salvo o Backup do Banco
BANCO=argonDB							# Nome do Banco de Dados
SYNC_LOG=/var/log/argon/bkpbanco/argonDB_dia_$DATAFEITO.log	# Diretorio onde sera salvo o Log 
TAREFA=BKP-BD							# Tarefa a ser executada pelo Script
EMAILCOPIA0=infraestrutura@argoninformatica.com.br		# Email em copia 0
EMAILCOPIA1=							# Email em copia 1
EMAILCOPIA2=							# Email em copia 2
#########################################################################################################################
#########################################################################################################################
#########################################################################################################################

$EXECUTAVEL/pg_dump --host $IP_HOST --port $PORT --username $USER --format custom --blobs --verbose --file $DIRECTORY_SAVE $BANCO 2>$SYNC_LOG

variavel=$?

if [ $variavel = "0" ];then
	cp $DIRECTORY_SAVE /backupDB/backupHDI/backup-argonDB/argonDB.backup
	echo "$variavel" > /work0/checknagios/check-bkp-argondb
	echo " " >> $SYNC_LOG
	echo "***************************************************************************************************" >> $SYNC_LOG
	echo " " >> $SYNC_LOG

	echo "BACKUP ArgonDB REALIZADO COM SUCESSO" >> $SYNC_LOG

	echo " " >> $SYNC_LOG
	echo "***************************************************************************************************" >> $SYNC_LOG
	echo " " >> $SYNC_LOG

exit 0 

			elif [ $variavel != "0" ];then

        			echo " " >> $SYNC_LOG
				echo "****************************************************************************" >> $SYNC_LOG
				echo " " >> $SYNC_LOG

				echo "BACKUP ArgonDB NÃO REALIZADO (ERRO)" >> $SYNC_LOG

				echo " " >> $SYNC_LOG
				echo "****************************************************************************" >> $SYNC_LOG	
				echo " " >> $SYNC_LOG

nohup /sbin/email.x $SYNC_LOG $TAREFA $CLIENTE $DATA $STATUSERRO $EMAILCOPIA0 $EMAILCOPIA1 $EMAILCOPIA2 &
ls
ls
sleep 20
clear

			exit 1

	PGPASSWORD=""
	export PGPASSWORD

fi
