vmname=$1
hadoop_home=/usr/local/hadoop
sudo apt-get update
sudo apt-get install -qqy openjdk-7-jdk
sudo groupadd hadoop
sudo useradd -m hadoop -g hadoop
echo 'wget hadoop.tar.gz may take a long time ......'
wget -nc -q -P /var/cache/wget http://mirror.nus.edu.sg/apache/hadoop/common/stable/hadoop-2.6.0.tar.gz
tar xvf /var/cache/wget/hadoop-2.6.0.tar.gz -C ~ > /dev/null
sudo rm -rf $hadoop_home
sudo mv hadoop-2.6.0 $hadoop_home
sudo chown -R hadoop:hadoop $hadoop_home
touch /tmp/hosts
if ! grep "master" /etc/hosts > /dev/null
then
cat /etc/hosts > /tmp/hosts
sed -i '/zhangyue/d' /tmp/hosts
cat << EOF >> /tmp/hosts
172.28.2.10 master zhangyue0
172.28.2.11 slave1 zhangyue1
172.28.2.12 slave2 zhangyue2
172.28.2.13 slave3 zhangyue3
EOF
sudo cp /tmp/hosts /etc/hosts
fi
