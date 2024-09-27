#!/usr/bin/env bash


function scan(){
	if [[ $# -eq 3 ]];then
		
		for (( i=$lesser_port ; i<=$more_port ; i++)){
			echo > /dev/null 2>&1 < /dev/tcp/${host}/${i}
			if [[ $? -eq 0 ]];then echo "[+] opened port : ${i}";else echo "[x] closed port : ${i}";fi
		}
		exit 0
	else
	
		echo > /dev/null 2>&1 < /dev/tcp/${host}/${port}
		if [[ $? -eq 0 ]];then echo "[+] opened port : ${port}";else echo "[x] closed port : ${i}";fi
		exit 0
	fi
	
}


function check_port(){
	if [[ $# -eq 2 ]];then
		if [[ $1 -gt 65635 || $2 -gt 65635 ]] || [[ $1 -lt 1 || $2 -lt 1 ]];then
			return 1
		fi
	else
		if [[ $1 -gt 65635 || $1 -lt 1 ]];then
			return 1
		fi
	fi

}



while getopts ":t:p:h" opt;do
		case ${opt} in
			t)
				host=${OPTARG}
				
				;;
			p)
				port=${OPTARG}
				
				;;
			h)
				echo "[+] USAGE: $0 -t <host> -p <port no>|<less port-high port>"
				exit 0
				;;	
			?)
				echo "[x] invalid option, -h for help"
				exit 1
				;;
			*)
				echo "[x] invalid option, -h for help"
				exit 1
		esac
	done



echo $port | grep -e "-" 1> /dev/null 2>&1
if [[ $? -eq 0 ]];then
	lesser_port=$(echo -n $port | cut -d "-" -f1)
	more_port=$(echo -n $port | cut -d "-" -f2)

	check_port $lesser_port $more_port
	if [[ $? -eq 1 ]];then	
		echo "[x] invalid port number"
		exit 1
	fi
	
	
	scan $host $lesser_port $more_port

else
	check_port $port
	if [[ $? -eq 1 ]];then
		echo "[x] invalid port number"
		exit 1
	fi
	scan $host $port

	
fi
