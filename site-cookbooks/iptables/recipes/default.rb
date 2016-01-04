#
# Cookbook Name:: iptables
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
simple_iptables_policy "INPUT" do
  policy "DROP"
end

simple_iptables_rule "loopback" do
  chain "system"
  rule "--in-interface lo"
  jump "ACCEPT"
end

simple_iptables_rule "established" do
  chain "system"
  rule "-m conntrack --ctstate ESTABLISHED,RELATED"
  jump "ACCEPT"
end

simple_iptables_rule "icmp" do
  chain "system"
  rule "--proto icmp"
  jump "ACCEPT"
end

simple_iptables_rule "ssh" do
  chain "system"
  rule "--proto tcp --dport 22"
  jump "ACCEPT"
end

simple_iptables_rule "http" do
  chain "system"
  rule "--proto tcp --dport 80"
  jump "ACCEPT"
end
