
ansible proxy

      environment:
        http_proxy: http://192.168.196.221:1087
        https_proxy: http://192.168.196.221:1087
        

mkdir -p /storage/data/opendevstack/ods/

cd /storage/data/opendevstack/ods/
sudo chown user.user /storage/data/opendevstack/

sudo rm -rf  ods-configuration 
sudo rm -rf  ods-configuration-sample
sudo rm -rf  ods-jenkins-shared-library
sudo rm -rf  ods-project-quickstarters
sudo rm -rf  ods-provisioning-app
sudo rm -rf  loca*
cd ods-core

find . -type f -name "*.sh" -exec chmod a+x {} \;



虚拟机存储位置调整
当前用户下设置此属性
vboxmanage setproperty machinefolder  /storage/data/virtualbox/user

压缩(不生效)
VBoxManage list hdds
VBoxManage modifymedium disk "/storage/data/virtualbox/user/opendevstack/centos-7.6-x86_64-disk001.vmdk" --compact

VBoxManage modifymedium disk "/home/user/VirtualBox VMs/opendevstack/atlcon/centos-7.6-x86_64-disk001.vmdk" --compact

迁移vm
VBoxManage export atlassian --output atlassian.ova
VBoxManage import atlassian.ova


VBoxManage export win2012_wf_installed_221_1057 --output win2012_wf_installed_221_1057.ova
VBoxManage import win2012_wf_installed_221_1057.ova


vagrant package --base=win2012_wf_installed_221_1057 --output=win2012_wf_installed_221_1057.box

vagrant box add win2012.box --name=win2012_wf_installed_221_1057


vagrant package --base=atlassian --output=atlassian.box

vagrant box add /storage/data/virtualbox/user/atlassian.box --name=atlassian_initialized

vagrant init atlassian_initialized atlassian

#迁移完成后之前的private_key无法自动登入 https://blog.pythian.com/vagrant-re-packaging-ssh/
# 在host机里面执行, 查看当前的 public key
ssh-keygen -y -f /storage/data/rndstack/ods-core/infrastructure-setup/.vagrant/machines/atlassian/virtualbox/private_key

# 在guest机里面执行 
vi ~/.ssh/authorized_keys
#paste进来 

#即可以使用ssh 的方式带私钥自动登入
vagrant ssh atlassian


# 使用ssh密码登录
     #machine_config.ssh.username = "vagrant"
     #machine_config.ssh.password = "vagrant"
     #machine_config.ssh.insert_key = true



curl -vvv --insecure   https://sonarqube-cd.192.168.56.101.nip.io/
curl -vvv --insecure   http://192.168.56.31:4440/



VBoxManage unregistervm --delete "atlassian"


Vagrant.configure("2") do |config|
  config.vm.box = "win2012_wf_installed_221_1057"
  config.vm.network "forwarded_port", guest: 3389, host: 4389
  config.vm.network "public_network", ip: "192.168.2.43"
  config.vm.provider "virtualbox" do |vb|
    vb.name = "win2012_wf_installed_221_1057"
    vb.gui = true
    vb.memory = "6144"
  end
end



架构调整 

从 
atlassian 192.168.56.31
opensift 192.168.56.101
atlcon 192.168.56.110

调整为

atlassian  192.168.1.4
opensift   192.168.1.5
atlcon     192.168.1.6


