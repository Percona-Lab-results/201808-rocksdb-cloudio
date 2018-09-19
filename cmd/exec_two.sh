for sz in `seq 2000 100 3400`
do

aws ec2 create-volume --region us-west-1 --availability-zone us-west-1c --volume-type gp2 --size=$sz  --tag-specifications 'ResourceType=volume,Tags=[{Key=Name,Value=Vadim-volume-1},{Key=iit-billing-tag,Value=vadim-perf}]'
aws ec2 wait volume-available --region us-west-1 --filters Name=tag:Name,Values=Vadim-volume-1 --query 'Volumes[*].{ID:VolumeId}' --region us-west-1
volid=$(aws ec2 describe-volumes  --filters Name=tag:Name,Values=Vadim-volume-1 --query 'Volumes[*].{ID:VolumeId}' --region us-west-1 --output text)
echo "Created volume $volid"
aws ec2 wait volume-available --region us-west-1 --volume-id $volid
sleep 5
aws ec2 attach-volume --region us-west-1 --volume-id $volid --instance-id i-0908d359f1a9ddf1c --device /dev/sde
sleep 5
aws ec2 wait volume-in-use --region us-west-1 --volume-id $volid
sleep 5

aws ec2 create-volume --region us-west-1 --availability-zone us-west-1c --volume-type gp2 --size=$sz  --tag-specifications 'ResourceType=volume,Tags=[{Key=Name,Value=Vadim-volume-2},{Key=iit-billing-tag,Value=vadim-perf}]'
aws ec2 wait volume-available --region us-west-1 --filters Name=tag:Name,Values=Vadim-volume-2 --query 'Volumes[*].{ID:VolumeId}' --region us-west-1
volid1=$(aws ec2 describe-volumes  --filters Name=tag:Name,Values=Vadim-volume-2 --query 'Volumes[*].{ID:VolumeId}' --region us-west-1 --output text)
echo "Created volume $volid1"
aws ec2 wait volume-available --region us-west-1 --volume-id $volid1
sleep 5
aws ec2 attach-volume --region us-west-1 --volume-id $volid1 --instance-id i-0908d359f1a9ddf1c --device /dev/sdk
sleep 5
aws ec2 wait volume-in-use --region us-west-1 --volume-id $volid1
sleep 5

#ssh -tt ec2-user@box_rocksdb.aws.vadimtk.com -i /home/vadim/keys/us-west-1.pem << EOF
ssh ec2-user@box_innodb.aws.vadimtk.com -i /home/vadim/keys/us-west-1.pem "sudo bash -x r_two.sh $sz"

aws ec2 detach-volume --region us-west-1 --volume-id $volid 
aws ec2 wait volume-available --region us-west-1 --volume-id $volid
aws ec2 delete-volume --region us-west-1 --volume-id $volid 
aws ec2 wait volume-deleted --region us-west-1 --volume-id $volid

aws ec2 detach-volume --region us-west-1 --volume-id $volid1
aws ec2 wait volume-available --region us-west-1 --volume-id $volid1
aws ec2 delete-volume --region us-west-1 --volume-id $volid1 
aws ec2 wait volume-deleted --region us-west-1 --volume-id $volid1

done
