#
# Cookbook Name:: ruby-env
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
rubyEnv = node['ruby-env']

%w{
  gcc git openssl-devel sqlite-devel readline-devel
}.each do |pkg|
  package pkg do
    action :install
  end
end

git "/home/#{ rubyEnv['user'] }/.rbenv" do
  repository rubyEnv['rbenv_url']
  action :sync
  user rubyEnv['user']
  group rubyEnv['group']
end

template '.bash_profile' do
  source '.bash_profile.erb'
  path "/home/#{ rubyEnv['user'] }/.bash_profile"
  owner rubyEnv['user']
  group rubyEnv['group']
  mode 0644
  not_if 'grep rbenv ~/.bash_profile', :environment => { :'HOME' => "/home/#{ rubyEnv['user'] }" }
end

directory "/home/#{ rubyEnv['user'] }/.rbenv/plugins" do
  user rubyEnv['user']
  group rubyEnv['group']
  mode 0755
  action :create
end

git "/home/#{ rubyEnv['user'] }/.rbenv/plugins/ruby-build" do
  repository rubyEnv['ruby-build_url']
  action :sync
  user rubyEnv['user']
  group rubyEnv['group']
end

execute "rbenv install #{ rubyEnv['version'] }" do
  command "/home/#{ rubyEnv['user'] }/.rbenv/bin/rbenv install #{ rubyEnv['version'] }"
  user rubyEnv['user']
  group rubyEnv['group']
  environment 'HOME' => "/home/#{ rubyEnv['user'] }"
  not_if { File.exists?("/home/#{ rubyEnv['user'] }/.rbenv/versions/#{ rubyEnv['version'] }") }
end

execute "rbenv global #{ rubyEnv['version'] }" do
  command "/home/#{ rubyEnv['user'] }/.rbenv/bin/rbenv global #{ rubyEnv['version'] }"
  user rubyEnv['user']
  group rubyEnv['group']
  environment 'HOME' => "/home/#{ rubyEnv['user'] }"
end

%w{ rbenv-rehash builder }.each do |gem|
  execute "gem install #{ gem }" do
    command "/home/#{ rubyEnv['user'] }/.rbenv/shims/gem install #{ gem }"
    user rubyEnv['user']
    group rubyEnv['group']
    environment 'HOME' => "/home/#{ rubyEnv['user'] }"
    not_if "/home/#{ rubyEnv['user'] }/.rbenv/shims/gem list | grep #{ gem }"
  end
end
