
function parse()
{

cat $1 | grep "thds:" | awk -v t=$2 '{  print substr($2, 1, length($2)-1)","$7","t } '

}

for i in `seq 500 100 3400`
do
parse res_sz${i}.txt rocksdb,gp2,$i
done

for i in `seq 1000 1000 30000`
do
parse res_iops${i}.txt rocksdb,io1,$i
done


