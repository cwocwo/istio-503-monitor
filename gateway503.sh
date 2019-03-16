gateways=$(kubectl -n istio-system get po|grep ingressgateway|awk '{print $1}')
for gateway in $gateways;
do
  gw_no=$(echo $gateway|awk -F- '{print $4}')
  kubectl -n istio-system logs $gateway --tail 100 -f|grep " 503 UC " >  ${gw_no}-503.log &
done
