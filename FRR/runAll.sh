#!/bin/bash

MAX_ITER=3
echo "Killing PREVIOUS controller terminal..."
sudo pkill -f controller.py
echo "Killing PREVIOUS packet injection..."
sudo pkill -f send_socket_path_id_0_multiple_packets.py
sudo pkill -f send_socket_path_id_1_multiple_packets.py
sudo pkill -f receive.py


A=('s1' 's2' 's3' 's4' 's5')
TIME_OUTS="10000 20000 30000 40000 50000 60000 70000 80000 90000 100000"

for k in $TIME_OUTS; do
	for ((j=0; j<${#A[@]}-1; j++)); do
		for (( i=1; i <=$MAX_ITER; i++ )); do
			#echo "----------------------------------------ITERATION $i/$MAX_ITER----------------------------------------"
			echo "Run controller in backgroud... with 'k' = $k, 'node1' = ${A[j]}, 'node2' = ${A[j+1]}"
			python controller.py $k ${A[j]} ${A[j+1]} &
			sleep 2
			echo "----------------------------------------ITERATION $i/$MAX_ITER----------------------------------------"
			#sudo /home/p4/mininet/util/m h2 python snd-rcv_scripts/receive.py &
			echo "Inject packets..."
			sudo /home/p4/mininet/util/m h1 python snd-rcv_scripts/send_socket_path_id_0_multiple_packets.py &
			#sudo /home/p4/mininet/util/m h1 python snd-rcv_scripts/send_socket_path_id_1_multiple_packets.py &
			echo "----------------------------------------ITERATION $i/$MAX_ITER----------------------------------------"
			sleep 8
			echo "Killing packet injection..."
			sudo pkill -f send_socket_path_id_0_multiple_packets.py
			sudo pkill -f send_socket_path_id_1_multiple_packets.py
			sudo pkill -f receive.py
			echo "Killing controller terminal..."
			sudo pkill -f controller.py
			sleep 1
		done
	done
done
#give file permissions to user
sudo chown $USER FRR_time*


B=('s1' 's5')
for k in $TIME_OUTS; do
	for ((j=0; j<${#B[@]}-1; j++)); do
		for (( i=1; i <=$MAX_ITER; i++ )); do
			#echo "----------------------------------------ITERATION $i/$MAX_ITER----------------------------------------"
			echo "Run controller in backgroud... with 'k' = $k, 'node1' = ${B[j]}, 'node2' = ${B[j+1]}"
			python controller.py $k ${B[j]} ${B[j+1]} &
			sleep 2
			echo "----------------------------------------ITERATION $i/$MAX_ITER----------------------------------------"
			#sudo /home/p4/mininet/util/m h2 python snd-rcv_scripts/receive.py &
			echo "Inject packets..."
			sudo /home/p4/mininet/util/m h1 python snd-rcv_scripts/send_socket_path_id_0_multiple_packets.py &
			#sudo /home/p4/mininet/util/m h1 python snd-rcv_scripts/send_socket_path_id_1_multiple_packets.py &
			echo "----------------------------------------ITERATION $i/$MAX_ITER----------------------------------------"
			sleep 8
			echo "Killing packet injection..."
			sudo pkill -f send_socket_path_id_0_multiple_packets.py
			sudo pkill -f send_socket_path_id_1_multiple_packets.py
			sudo pkill -f receive.py
			echo "Killing controller terminal..."
			sudo pkill -f controller.py
			sleep 1
		done
	done
done
#give file permissions to user
sudo chown $USER FRR_time*

