# 8640 sleep 10s ~ 1 dia
# 4320 sleep 10s ~ 14 horas ~ 8M
DATA="`date +%d%m%Y`"
cont=0
while [ $cont -lt 3 ]; \
do (echo "$(date)" \
&& echo "LoadAverage: $(cat /proc/loadavg)" \
&& echo "$(awk '$3=="kB"{$2=$2/1024;$3="MB"} 1' /proc/meminfo | awk 'NR==2{print $1,$2,$3}') | $(awk '$3=="kB"{$2=$2/1024;$3="MB"} 1' /proc/meminfo | awk 'NR==1{print $1,$2,$3}')" \
&& echo "-" \
&& sar -p -d 1 1 | awk 'NR==2' RS="\n\n" \
&& echo "-" \
&& sar -n DEV 1 1 | awk 'NR==2' RS="\n\n" \
&& echo "-" \
&& ps -e -o user,pcpu,pmem,args --sort=-pcpu | cut -d" " -f1-12 | head -n9 && echo _______________________________________________) >> /tmp/cpuload_$DATA.log; sleep 10;let cont=cont+1; done &
