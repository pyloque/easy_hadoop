vmname=$1
hadoop_home=/usr/local/hadoop
spark_home=/usr/local/spark

function add_user()
{
    sudo groupadd hadoop
    sudo useradd -m hadoop -g hadoop
    echo hadoop:hadoop | sudo chpasswd
}

function install_tools()
{
    sudo apt-get update
    sudo apt-get install -qqy openjdk-7-jdk
    sudo apt-get install -qqy scala
}

function install_pkg()
{
    echo 'wget hadoop.tar.gz may take a long time ......'
    wget -nc -q -P /var/cache/wget http://mirror.nus.edu.sg/apache/hadoop/common/stable/hadoop-2.6.0.tar.gz
    echo 'wget spark.tgz may take a long time ......'
    wget -nc -q -P /var/cache/wget http://mirror.nus.edu.sg/apache/spark/spark-1.2.1/spark-1.2.1-bin-hadoop2.4.tgz 
    tar xvf /var/cache/wget/hadoop-2.6.0.tar.gz -C ~ > /dev/null
    tar xvf /var/cache/wget/spark-1.2.1-bin-hadoop2.4.tgz -C ~ > /dev/null
    if [ -d $hadoop_home ]
    then
        sudo rm -rf $hadoop_home
    fi
    if [ -d $spark_home ]
    then
        sudo rm -rf $spark_home
    fi
    sudo mv hadoop-2.6.0 $hadoop_home
    sudo mv spark-1.2.1-bin-hadoop2.4 $spark_home
    sudo chown -R hadoop:hadoop $hadoop_home
    sudo chown -R hadoop:hadoop $spark_home
}

function write_hosts()
{
    touch /tmp/hosts
    if ! grep "master" /etc/hosts > /dev/null
    then
    cat /etc/hosts > /tmp/hosts
    sed -i '/zhangyue/d' /tmp/hosts
    cat << EOF >> /tmp/hosts
172.28.2.10 master zhangyue0
172.28.2.11 slave1 zhangyue1
172.28.2.12 slave2 zhangyue2
EOF
    sudo cp /tmp/hosts /etc/hosts
    fi
}

add_user
install_tools
install_pkg
write_hosts
