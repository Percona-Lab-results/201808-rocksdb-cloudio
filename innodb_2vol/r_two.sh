mdadm --create --verbose /dev/md0 --level=0 --name=MY_RAID --raid-devices=2 /dev/sde /dev/sdk

mkfs.ext4  /dev/md0
mount /dev/md0 /mnt/data

cp -r /mnt/backup/mysql.innodb /mnt/data/mysql
chown mysql.mysql -R /mnt/data/mysql
systemctl start mysql
cd /home/vadim/sysbench-tpcc
vmstat 1 > vmstat_two_${1}.out &
PIDDSTATSTAT=$!
bash run_tpcc.sh | tee -a res_iops_two${1}.txt
set +e
kill $PIDDSTATSTAT
set -e
systemctl stop mysql

umount /dev/md0
mdadm --stop /dev/md0
