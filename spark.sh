vmname=$1
hadoop_home=/usr/local/hadoop
hadoop_etc=$hadoop_home/etc/hadoop
spark_home=/usr/local/spark
spark_conf=$spark_home/conf

function write_slaves()
{
    cat << EOF > $spark_conf/slaves
slave1
slave2
EOF
}

function write_env()
{
    cat << EOF > $spark_conf/spark_env.sh
export JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk-amd64
export SCALA_HOME=/usr/share/java
export HADOOP_HOME=/usr/local/hadoop
EOF
}

function start_spark()
{
    if [ "$vmname" == "zhangyue0" ]
    then
        cd $spark_home
        echo "hadoop\nhadoop\n" | sbin/start-all.sh
    fi
}

write_slaves
write_env
# start_spark
