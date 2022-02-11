#!/bin/bash -x

list_fast_all_nmap() {
    if [[ $# -eq 1 ]];then
        echo $#
        if [[ $# -eq 1 ]];then
          for i in $(cat $1);do
            echo "${i}" 
            dirname=$( echo "${i}" | cut -d "/" -f1)
            mkdir -p ${result_dir}/"${dirname}"
            nmap -sS -A -T4 --max-scan-delay 500ms -g 53 -max-retries 2 -p- -oA "${result_dir}/${dirname}/${dirname}_nmap_results" ${i}
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
            mkdir -p ${result_dir}/"${dirname}"
            nmap -sU -A -T4 --max-scan-delay 500ms -max-retries 2 -p- -g 53 -oA "${result_dir}/${dirname}/${dirname}_nmap_results" ${i}
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
    result_dir="/tmp/"
    check_params "$@"
    parse_params "$@"
}

main "$@"
