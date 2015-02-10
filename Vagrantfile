# -*- mode: ruby -*-

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.proxy.http = "http://59.151.100.77:33100"
  config.proxy.https = "https://59.151.100.77:33100"
  config.proxy.no_proxy = "localhost,127.0.0.1"
  config.cache.scope = :box
  config.cache.enable :generic, {
    "wget" => { cache_dir: "/var/cache/wget" }    
  }
  3.times do |i|
    config.vm.define vmname="zhangyue%d" % i do |config|
        config.vm.hostname = vmname
        config.vm.network "private_network", ip: "172.28.2.1%s" % i
        config.vm.provider "virtualbox" do |vb|
            memsize = "1024"
            memsize = "2048" if i == 0
            vb.customize ["modifyvm", :id, "--memory", memsize]
        end
        config.vm.provision :shell, :path => "./vagrant.sh", :args => vmname, :privileged => false
        config.vm.provision :file, :source => "./hadoop.sh", :destination => "hadoop.sh"
        config.vm.provision :file, :source => "./spark.sh", :destination => "spark.sh"
        config.vm.provision :shell, :inline => "mv hadoop.sh /home/hadoop/hadoop.sh", :privileged => true
        config.vm.provision :shell, :inline => "mv spark.sh /home/hadoop/spark.sh", :privileged => true
        config.vm.provision :shell, :inline => "sudo su -l hadoop -c 'bash hadoop.sh %s'" % vmname, :privileged => false
        config.vm.provision :shell, :inline => "sudo su -l hadoop -c 'bash spark.sh %s'" % vmname, :privileged => false
    end
  end
end
