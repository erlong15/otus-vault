# -*- mode: ruby -*-
# vi: set ft=ruby :
nodes = {
  :vault => {
        :box_name => "centos/7",
        :ip_addr => '192.168.70.150',
  },
  :nginx => {
        :box_name => "centos/7",
        :ip_addr => '192.168.70.151',
  },
  :consul => {
        :box_name => "centos/7",
        :ip_addr => '192.168.70.152',
  },
}

Vagrant.configure(2) do |config|
  nodes.each do |boxname, boxconfig|

      config.vm.define boxname do |box|

          box.vm.box = boxconfig[:box_name]
          box.vm.host_name = boxname.to_s
          box.vm.network "private_network", {ip: boxconfig[:ip_addr], adapter: 2}
	  box.vm.provider :virtualbox do |vb|
             vb.customize ["modifyvm", :id, "--memory", "1024"]
             vb.customize ["modifyvm", :id, "--cableconnected1", "on"]
          end

          #box.vm.provision "ansible" do |ansible|
          #  ansible.playbook = "site.yml"
          #   ansible.become = true
          #end
      end
  end
end
