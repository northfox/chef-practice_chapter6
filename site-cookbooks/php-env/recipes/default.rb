#
# Cookbook Name:: php-env
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
base_package = 'php-fpm'

%W{
  #{ base_package }
  php-pecl-zendopcache
}.each do |pkg|
  package pkg do
    action :install
    notifies :restart, "service[#{ base_package }]"
  end
end

service base_package do
  action [ :enable, :start ]
end

template 'index.php' do
  path '/usr/share/nginx/html/index.php'
  source 'index.php.erb'
  owner 'root'
  group 'root'
  mode 0644
end
