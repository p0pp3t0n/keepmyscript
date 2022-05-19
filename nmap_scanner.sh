#!/bin/bash

fast_nmap_script() {
    if [[ $# -eq 2 ]];then
        mkdir -p ${result_dir}/$2
        nmap -sS -sV -sC -A -T4 --max-scan-delay 500ms -max-retries 2 -PE -PP -p- -g 53 -oA "${result_dir}/$2/$2_all_fast" $1
    else
        script_usage
    fi
}

fast_all_nmap_script() {
    if [[ $# -eq 1 ]];then
        mkdir -p ${result_dir}/$2
        nmap -sS -sV -sC -A -T4 --max-scan-delay 500ms -max-retries 2 -PE -PP -PS80,443 -PA3389 -PU40125 -g 53 -oA "${result_dir}/$2/$2_fast" $1
    else
        script_usage
    fi
}

fast_nmap_script_list() {
    if [[ $# -eq 1 ]];then
        echo $#
        if [[ $# -eq 1 ]];then
          for i in $(cat $1);do
            dirname=$( echo "${i}" | cut -d "/" -f1)
            mkdir -p ${result_dir}/"${dirname}"
            nmap -sV -sC -T4 -Pn -max-retries 2 -p- -g 53 -oA "${result_dir}/${dirname}/${dirname}_nmap_results" ${i}
          done
        fi
    else
        script_usage
    fi
}

slow_nmap() {
    if [[ $# -eq 2 ]];then
        mkdir -p ${result_dir}/$2
        nmap -sS -A -T2 --max-scan-delay 500ms -max-retries 2 -PE -PP -PS80,443 -PA3389 -PU40125 -g 53 -oA "${result_dir}/$2/$2_slow" $1
    else
        script_usage
    fi
}

list_slow_nmap() {
    if [[ $# -eq 2 ]];then
        echo $#
        if [[ $# -eq 1 ]];then
          for i in $(cat $1);do
            dirname=$( echo "${i}" | cut -d "/" -f1)
            mkdir -p ${result_dir}/"${dirname}"
            nmap -sS -A -T2 --max-scan-delay 500ms -max-retries 2 -PE -PP -PS80,443 -PA3389 -PU40125 -g 53 -oA "${result_dir}/${dirname}/${dirname}_nmap_results" ${i}
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
     $0 -q 10.10.10.1 hostname/range   Will perform a slow nmap scan 
     $0 -l list_file                   Will perform a slow nmap scan with a list
     $0 -s 10.10.10.1 hostname/range   Will perform a fast nmap scan 
     $0 -sl list_file                  Will perform a fast nmap scan with a list

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
            -l | --list)
                list_slow_nmap "$@"
                exit 0
                ;;
            -fa | --fall)
                fast_all_nmap_script "$@"
                exit 0
                ;;
            -q | --quick)
                slow_nmap "$@"
                exit 0
                ;;
            -s | --fastscript)
                fast_nmap_script "$@"
                exit 0
                ;;
            -sl | --fastscriptlist)
                fast_nmap_script_list "$@"
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
