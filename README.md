# easy_hadoop
用虚拟机搭建hadoop2.6完全分布式环境

```
172.28.2.10 master zhangyue0
172.28.2.11 slave1 zhangyue1
172.28.2.12 slave2 zhangyue2
172.28.2.13 slave3 zhangyue3
```

安装环境
```
brew install vagrant
brew install virtualbox
vagrant plugin install vagrant-cachier
vagrant plugin install vagrant-proxyconf
vagrant box add ubuntu/trusty64 <box_url>
vagrant up
```

跑任务
```
vagrant ssh zhangyue0
sudo su - hadoop
cd /usr/local/hadoop
bin/hdfs dfs -mkdir /user
bin/hdfs dfs -mkdir /user/hadoop
bin/hdfs dfs -put etc/hadoop input
bin/hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-2.6.0.jar grep input output 'property'
bin/hadoop dfs -get output output
```

管理控制台
```
http://172.28.2.10:8088/ hadoop resourcemanager webapp
http://172.28.2.10:19888/ hadoop jobhistory webapp
```
