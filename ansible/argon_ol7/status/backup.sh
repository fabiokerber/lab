#!/bin/bash
# Script para realizacao de backup em hd externo
# Criado por Aécio Oliveira
#VERSION 1.1 - Criação do Script com o intuito de mais praticidade nos backups e nas manutenções.
#VERSION 1.2 - Manter um log, para cada script de backup, status, backup do banco de dados e servidor reserva
#VERSION 1.3 - Foi acrescentado o comando para desmontar qualquer disco antes da execução do backup
####################################################################################################################
##########################Variaveis Fixa############################################################################
ano=$(date +%y)                         # Atribui o ano atual a variavel ano.
mes=$(date +%m)                         # Atribui o mes atual a variavel mes.
dia=$(date +%d)                         # Atribui o dia atual a variavel dia.
diadasemana=$(date +%A)                 # Atribui o dia atual a variavel dia.
ipwan=$(wget -q -O - http://whatismyip.akamai.com/) # Atribui o IP
datastatus=`date +%a-%d-%m-%Y-%H:%M`                # Status da Data
dia_semana="`date +%A`"                   # Atribui o dia da semana.
/bin/touch /var/log/argon/bkpexterno/bkpexterno_$dia-$mes-$ano.log  # Cria o Log
SYNC_LOG=/var/log/argon/bkpexterno/bkpexterno_$dia-$mes-$ano.log    # Local armazenamento do log
databkp=`date +%a-%d-%m-%Y-%H:%M`       # Data do Backup
DATA=$dia-$mes-$ano
STATUSOK=OK
STATUSERRO=ERRO
####################################################################################################################
#############################################Variaveis Declaradas###################################################
####################################################################################################################
CLIENTE=PENHA								#NOME DO NOSSO CLIENTE
SISTEMAS=/work1/sistemas/						#DIRETORIO DE SISTEMAS
IMAGENS=/work1/imagens/							#DIRETORIO DE IMAGENS
DOCUMENTOS=/work1/documentos/						#DIRETORIO DE DOCUMENTOS
BKPBANCO=/backupDB/backupHDI/backup-argonDB/				#DIRETORIO ONDE E FEITO O BACKUP DO BANCO
TAMANHO_DISCO=/work0/checknagios/tamanho_disco			        #TAMANHO DISCO
STATUSPLUGIN=/work0/checknagios/statusplugin                           	#STATUS para plugin de checagem
TAREFA=BKP-ARQUIVOS							#TAREFA
EMAILCOPIA0=infraestrutura@argoninformatica.com.br  		        #EMAIL EM COPIA 0
EMAILCOPIA1=								#EMAIL EM COPIA 1
EMAILCOPIA2=								#EMAIL EM COPIA 2
###################################################################################################################
#######################################Label dos discos############################################################
################################################################################################################### 
LABEL1=hdbackup-1  #LABEL DISCO 1, ESTE A ID E FORNECIDO ATRAVES DO COMANDO e2label
SISTEMA_ARQUIVOS_DISCO1=ext4
LABEL2=hdbackup-2 #LABEL DISCO 2
SISTEMA_ARQUIVOS_DISCO2=ext4
LABEL3=hdbackup-3 #LABEL DISCO 3
SISTEMA_ARQUIVOS_DISCO3=ext4
####################################################################################################################
####################################################################################################################
####################################################################################################################
echo "####################Execucao de Backup - Unidade Externa######################################" >> $SYNC_LOG
echo " " >> $SYNC_LOG
echo "##############################################################################################" >> $SYNC_LOG
echo "Cliente= $CLIENTE - Backup para HD externo" >> $SYNC_LOG
echo "IP= $ipwan" >> $SYNC_LOG
echo "Identificação: $(uname -a)" >> $SYNC_LOG
echo "Uptime: $(uptime)" >> $SYNC_LOG
echo "Data: $datastatus" >> $SYNC_LOG
echo " " >> $SYNC_LOG
####################################################################################################################
######################################Montando disco################################################################
####################################################################################################################
umount /backup/usbdisk-1
umount /backup/usbdisk-2
umount /backup/usbdisk-3

mkdir /backup/usbdisk-1
mkdir /backup/usbdisk-2
mkdir /backup/usbdisk-3

temp1=`mount -t$SISTEMA_ARQUIVOS_DISCO1 -L$LABEL1 /backup/usbdisk-1 -o defaults`

VARIAVEL=$?

if [ $VARIAVEL = 0 ];then

DISCO=/backup/usbdisk-1

elif temp2=`mount -t$SISTEMA_ARQUIVOS_DISCO2 -L$LABEL2 /backup/usbdisk-2 -o defaults`;then

DISCO=/backup/usbdisk-2

elif temp3= `mount -t$SISTEMA_ARQUIVOS_DISCO3 -L$LABEL3 /backup/usbdisk-3 -o defaults`;then

DISCO=/backup/usbdisk-3
				else

echo "#############################Estado dos discos################################################" >> $SYNC_LOG
echo " " >>$SYNC_LOG
df -h >> $SYNC_LOG     #CASO NECESSARIO CHECAR AS PASTAS UTILIZE O STATUS POR EMAIL
echo "##############################################################################################" >> $SYNC_LOG

			echo "Backup nao efetuado em $databkp. Unidades de Backup nao foi encontrada." >> $SYNC_LOG

echo "naoefetuado" >> $STATUSPLUGIN

unix2dos $SYNC_LOG

/sbin/sendEmail -f log.infra@argoninformatica.com.br -t infraestrutura@argoninformatica.com.br -u $TAREFA $CLIENTE $DATA $STATUSERRO -a $SYNC_LOG -m $TAREFA $CLIENTE $DATA $STATUSERRO -o tls=yes -s smtp.googlemail.com:587 -xu log.infra@argoninformatica.com.br -xp S3nh@1995 -cc $EMAILCOPIA0 -cc $EMAILCOPIA1 -cc $EMAILCOPIA2 -cc $EMAILCOPIA3

exit 1
	
fi	
####################################################################################################################
################################Inicio do backup####################################################################

echo "#############################Estado dos discos################################################" >> $SYNC_LOG
echo " " >>$SYNC_LOG
df -h >> $SYNC_LOG     #CASO NECESSARIO CHECAR AS PASTAS UTILIZE O STATUS POR EMAIL
echo "##############################################################################################" >> $SYNC_LOG

	echo "Inicio da sincronizacao" >> $SYNC_LOG
	data_ini=`date +%d-%m-%y-%a+%H:%M`
	echo "---- AGUARDE... Iniciando sincronizacao em $data_ini ----"
	echo "---- AGUARDE... Iniciando sincronizacao em $data_ini ----" >> $SYNC_LOG

rsync -avzpogt $SISTEMAS    	$DISCO/sistemas/ >> $SYNC_LOG
rsync -avzpogt $IMAGENS     	$DISCO/imagens/ >> $SYNC_LOG
rsync -avzpogt $DOCUMENTOS  	$DISCO/documentos/ >> $SYNC_LOG
rsync -avzpogt $BKPBANCO    	$DISCO/bkpbanco/ >> $SYNC_LOG

	echo " " >> $SYNC_LOG
	data_ini=`date +%d-%m-%y-%a+%H:%M`
  	data_ini=`date +%d-%m-%y-%a+%H:%M` >> $SYNC_LOG
	echo " " >> $SYNC_LOG
 	echo "---- Fim da sincronizacao em ...$data_ini ----" >> $SYNC_LOG
echo "#############################################################################################" >> $SYNC_LOG

df --block-size G | egrep usbdisk-* | sed -e "s/[[:space:]]\+/ /g" -e 's/^[[:space:]]*\+\([0-9]\+\)[[:space:]]\+/\1\t/g' -e "s, ,:,g;s/$//" > $TAMANHO_DISCO   #checar espaço disco externo de backup   

NUMERO_DISCO=`cat $TAMANHO_DISCO | egrep usbdisk-* | cut -d ':' -f6 | cut -c 17`

echo data_$datastatus >> $TAMANHO_DISCO

cat $TAMANHO_DISCO > $TAMANHO_DISCO-$NUMERO_DISCO
 
echo "$NUMERO_DISCO" >> $STATUSPLUGIN
	
/bin/umount $DISCO >> $SYNC_LOG

unix2dos $SYNC_LOG

/sbin/sendEmail -f log.infra@argoninformatica.com.br -t infraestrutura@argoninformatica.com.br -u $TAREFA $CLIENTE $DATA $STATUSOK -a $SYNC_LOG -m $TAREFA $CLIENTE $DATA $STATUSOK -o tls=yes -s smtp.googlemail.com:587 -xu log.infra@argoninformatica.com.br -xp S3nh@1995 -cc $EMAILCOPIA0 -cc $EMAILCOPIA1 -cc $EMAILCOPIA2 -cc $EMAILCOPIA3

exit 0
###################################################################################################################
