gateways=$(kubectl -n istio-system get po|grep ingressgateway|awk '{print $1}'|awk -F- '{print $4}')
declare -A file_old_stats=()
for gateway in $gateways; do
  file_old_stats[$gateway]="0"
done

function whether_changed(){
    gateway=${1}
    local file_path=${gateway}-503.log
    file_new_stat="`stat ${file_path}|grep Size`"
    file_old_stat=${file_old_stats[${gateway}]}
    
    if [[ `echo ${file_old_stat}` == `echo ${file_new_stat}` ]]; then
        echo "### ${file_path} does not change ###"
    else
        file_old_stats[$gateway]=${file_new_stat}
        echo "### ${file_path}  changed: ${file_old_stats[$gateway]}  ###"
        echo "cn-north-3 503 error"|mail -s "cn north3 503 error-$gateway"  19092057@qq.com < $file_path
    fi
}

while [[ true ]]; do
  for gateway in $gateways; do
    whether_changed $gateway
  done  
  sleep 10
done


# echo "cn-north-3 503 error"|mail -s "cn north3 503 error"  19092057@qq.com 249333569@qq.com 93676341@qq.com
