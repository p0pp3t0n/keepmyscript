#!/bin/bash -x

ping_sweep() {
 	echo "Starting the ping sweep"

	SCTP="7,9,20-22,80,179,443,1021,1022,1167,1720,1812,1813,2049,2225,2427,2904,2905,2944,2945,3097,3565,3863-3868,4195,4333,4502,4711,4739,4740,5060,5061,5090,5091,5215,5445,5060,5672,5675,5868,5910-5912,5913,6701-6706,6970,7626,7701,7728,8282,8471,9082,9084,9899-9902,11997-11999,14001,20049,25471,29118,29168,29169,30100,36412,36422-36424,36443,36444,36462,38412,38422,38462,38472"
	TCP="7,9,13,21-23,25-26,37,53,79-81,88,106,110-111,113,119,135,139,143-144,179,199,389,427,443-445,465,513-515,543-544,548,554,587,631,646,873,990,993,995,1025-1029,1110,1433,1720,1723,1755,1900,2000-2001,2049,2121,2717,3000,3128,3306,3389,3986,4899,5000,5009,5051,5060,5101,5190,5357,5432,5631,5666,5800,5900,6000-6001,6646,7070,8000,8008-8009,8080-8081,8443,8888,9100,9999-10000,32768,49152-49157"
	UDP="53,67,123,135,137-138,161,445,631,1434"

	nmap -oN $RESULT_DIR/ping_sweep_n.txt -sn -n --packet-trace --disable-arp-ping ${i} > /dev/null &
	nmap -oN $RESULT_DIR/ping_sweep_s.txt -sn -n --packet-trace -PS$TCP --disable-arp-ping ${i} > /dev/null &
	nmap -oN $RESULT_DIR/ping_sweep_a.txt -sn -n --packet-trace -PA$TCP --disable-arp-ping ${i} > /dev/null &
	nmap -oN $RESULT_DIR/ping_sweep_u.txt -sn -n --packet-trace -PU$UDP --disable-arp-ping ${i} > /dev/null &
	nmap -oN $RESULT_DIR/ping_sweep_y.txt -sn -n --packet-trace -PY$SCTP --disable-arp-ping ${i} > /dev/null &
	nmap -oN $RESULT_DIR/ping_sweep_e.txt -sn -n --packet-trace -PE --disable-arp-ping ${i} > /dev/null &
	nmap -oN $RESULT_DIR/ping_sweep_p.txt -sn -n --packet-trace -PP --disable-arp-ping ${i} > /dev/null &
	nmap -oN $RESULT_DIR/ping_sweep_m.txt -sn -n --packet-trace -PM --disable-arp-ping ${i} > /dev/null &
	nmap -oN $RESULT_DIR/ping_sweep_o.txt -sn -n --packet-trace -PO2 --disable-arp-ping ${i} > /dev/null &
  wait

 	echo "Done with the ping sweep"
}

list_fast_all_nmap() {
    if [[ $# -eq 1 ]];then
        echo $#
        if [[ $# -eq 1 ]];then
          for i in $(cat $1);do
            echo "${i}" 
            dirname=$( echo "${i}" | cut -d "/" -f1)
            mkdir -p ${RESULT_DIR}/"${dirname}"
            nmap -sS -A -T4 --max-scan-delay 500ms -g 53 -max-retries 2 -p- -oA "${RESULT_DIR}/${dirname}/${dirname}_nmap_results" ${i}
          done
        fi
    else
        script_usage
    fi
}
list_fast_all_udp_nmap() {
    if [[ $# -eq 1 ]];then
        echo $#
        if [[ $# -eq 1 ]];then
          for i in $(cat $1);do
            echo "${i}" 
            dirname=$( echo "${i}" | cut -d "/" -f1)
            mkdir -p ${RESULT_DIR}/"${dirname}"
            nmap -sU -A -T4 --max-scan-delay 500ms -max-retries 2 -p- -g 53 -oA "${RESULT_DIR}/${dirname}/${dirname}_nmap_results" ${i}
          done
        fi
    else
        script_usage
    fi
}



function script_usage() {
    cat << EOF

Default description

Usage:
     $0 -lfa list_file                  Will perform a fast(T4) nmap scan (all ports) with a list
	   $0 -ulfa list_file                  Will perform a fast(T4) nmap (all ports udp) scan with a list

EOF
}

check_params() {
    if [[ $# -lt 1 ]]; then
      script_usage
      exit 0
    fi
}

parse_params() {
    local param
    while [[ $# -gt 0 ]]; do
        param="$1"
        shift
        case $param in
            -h | --help)
                script_usage
                exit 0
                ;;
            -lfa | --lfall)
                list_fast_all_nmap "$@"
                exit 0
                ;;
            -ulfa | --ulfall)
                list_fast_all_udp_nmap "$@"
                exit 0
                ;;
            *)
                echo "Invalid parameters"
                exit 0
                ;;
        esac
    done
}

function main() {
    RESULT_DIR="/tmp/"
    check_params "$@"
    parse_params "$@"
}

main "$@"
