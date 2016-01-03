Vagrant.configure(2) do |config|
  config.vm.box = 'vagrant-base'
  config.vm.network 'private_network', ip: '192.168.33.10'
  
  config.omnibus.chef_version = :latest
  
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ['./cookbooks', './site-cookbooks']
    chef.run_list = %w(
      recipe[yum-epel]
      recipe[nginx]
    )
  end
end
