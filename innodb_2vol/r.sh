mkfs.ext4 /dev/sde
mount /dev/sde /mnt/data
cp -r /mnt/backup/mysql.innodb /mnt/data/mysql
chown mysql.mysql -R /mnt/data/mysql
systemctl start mysql
cd /home/vadim/sysbench-tpcc
vmstat 1 > vmstat_${1}.out &
PIDDSTATSTAT=$!
bash run_tpcc.sh | tee -a res_iops${1}.txt
set +e
kill $PIDDSTATSTAT
set -e
systemctl stop mysql
