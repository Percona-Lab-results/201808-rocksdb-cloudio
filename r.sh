mkfs.ext4 /dev/sde
mount /dev/sde /mnt/data
cp -r /mnt/backup/mysql.innodb /mnt/data/mysql
chown mysql.mysql -R /mnt/data/mysql
systemctl start mysql
cd /home/vadim/sysench-tpcc
bash run_tpcc.sh | tee -a res_iops${1}.txt
systemctl stop mysql
