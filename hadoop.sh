vmname=$1
hadoop_home=/usr/local/hadoop
hadoop_etc=$hadoop_home/etc/hadoop
if [ ! -f ~/.ssh/id_dsa ]
then
ssh-keygen -q -t dsa -P '' -f ~/.ssh/id_dsa
cat ~/.ssh/id_dsa.pub >> ~/.ssh/authorized_keys
fi
cd $hadoop_home
sed -i 's/\${JAVA_HOME}/\/usr\/lib\/jvm\/java-1.7.0-openjdk-amd64/g' $hadoop_etc/hadoop-env.sh
mkdir -p ~/namenode
mkdir -p ~/datanode
cat << EOF >  $hadoop_etc/core-site.xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://master:9000</value>
    </property>
</configuration>
EOF
cat << EOF > $hadoop_etc/hdfs-site.xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
    <property>
        <name>dfs.replication</name>
        <value>2</value>
    </property>
    <property>
        <name>dfs.namenode.name.dir</name>
        <value>file:/home/hadoop/namenode</value>
    </property>
    <property>
        <name>dfs.datanode.data.dir</name>
        <value>file:/home/hadoop/datanode</value>
    </property>
</configuration>
EOF
cat << EOF > $hadoop_etc/yarn-site.xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
    <property>
　　    <name>yarn.resourcemanager.address</name>
　　    <value>master:8032</value>
    </property>
    <property>
    　　<name>yarn.resourcemanager.scheduler.address</name>
    　　<value>master:8030</value>
    </property>
    <property>
    　　<name>yarn.resourcemanager.resource-tracker.address</name>
    　　<value>master:8031</value>
    </property>
    <property>
    　　<name>yarn.resourcemanager.admin.address</name>
    　　<value>master:8033</value>
    </property>
    <property>
    　　<name>yarn.resourcemanager.webapp.address</name>
    　　<value>master:8088</value>
    </property>
    <property>
        <name>yarn.nodemanager.aux-services</name>
        <value>mapreduce_shuffle</value>
    </property>
    <property>
        <name>yarn.nodemanager.aux-services.mapreduce.shuffle.class</name>
        <value>org.apache.hadoop.mapred.ShuffleHandler</value>
    </property>
</configuration>
EOF
cat << EOF > $hadoop_etc/mapred-site.xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
    </property>
    <property>
        <name>mapreduce.jobhistory.address</name>
        <value>master:10020</value>
    </property>
    <property>
        <name>mapreduce.jobhistory.webapp.address</name>
        <value>master:19888</value>
    </property>
</configuration>
EOF
if [ "$vmname" == "zhangyue0" ]
then
    if [ ! -d ~/namenode/current ]
    then
    bin/hdfs namenode -format
    fi
    sbin/hadoop-daemon.sh start namenode
    sbin/yarn-daemon.sh start resourcemanager 
    sbin/yarn-daemon.sh start proxyserver 
    sbin/mr-jobhistory-daemon.sh start historyserver
else
    sbin/hadoop-daemon.sh start datanode
    sbin/yarn-daemon.sh start nodemanager
fi
