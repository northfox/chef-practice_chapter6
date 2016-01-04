#
# Cookbook Name:: nodejs
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
tmp = Chef::Config[:file_cache_path]
nodejs = node['nodejs']

%w{ gcc-c++ }.each do |pkg|
  package pkg do
    action :install
  end
end

remote_file "#{ tmp }/#{ nodejs['filename'] }" do
  source nodejs['remote_uri']
end

bash 'install nodejs' do
  user 'root'
  cwd tmp
  code <<-EOC
    tar xzvf #{ nodejs['filename'] }
    cd #{ nodejs['dirname'] }
    make && make install
  EOC
  not_if "which node"
end
