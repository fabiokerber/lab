##########################Variaveis Fixa#################################################################################################
PATH=/opt/someApp/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ano=$(date +%y)                         				# Atribui o ano atual a variavel ano.
mes=$(date +%m)                         				# Atribui o mes atual a variavel mes.
dia=$(date +%d)                         				# Atribui o dia atual a variavel dia.
diadasemana=$(date +%A)                 				# Atribui o dia atual a variavel dia.
ipwan=$(wget -q -O - http://whatismyip.akamai.com/) 			# Atribui o IP
datastatus=`date +%a-%d-%m-%Y-%H:%M`                			# Status da Data
dia_semana="`date +%A`"                   				# Atribui o dia da semana.
/bin/touch /var/log/argon/badblock/badblock_$dia-$mes-$ano.log  	# Cria o Log
SYNC_LOG=/var/log/argon/badblock/badblock_$dia-$mes-$ano.log    	# Local armazenamento do log
databkp=`date +%a-%d-%m-%Y-%H:%M`       				# Data do Backup
DATA=$dia-$mes-$ano							# Data
########################################Variaveis Declaradas#######################################################################
CLIENTE=TATUAPE28                                                  #NOME DO NOSSO CLIENTE
DISCO1=sda                                                         #Disco 1
DISCO2=sdb                                                         #Disco 2
DISCO3=sdc					                   #Disco 3
BADBLOCK=/var/log/argon/badblock/discos			   #Caminho onde sera salvo a saida do comando para checagem do nagios
###################################################################################################################################

badblocks -v -o $BADBLOCK/blocos-defeituosos_$DISCO1.lista /dev/$DISCO1

badblocks -v -o $BADBLOCK/blocos-defeituosos_$DISCO2.lista /dev/$DISCO2

badblocks -v -o $BADBLOCK/blocos-defeituosos_$DISCO3.lista /dev/$DISCO3

exit
