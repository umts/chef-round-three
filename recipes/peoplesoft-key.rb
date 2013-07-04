#
# Cookbook Name:: round-three
# Recipe:: peoplesoft-key
#
# Copyright 2013, UMass Transit Service
#
# All rights reserved - Do Not Redistribute
#
round_three_secrets = Chef::EncryptedDataBagItem.load("apps", "round-three")
key = round_three_secrets['peoplesoft_key']

file "#{node['round-three']['dir']}/shared/peoplesoft.dsa" do
  owner node['apache']['user']
  mode 0600
  content key
end

link "#{node['round-three']['dir']}/current/config/peoplesoft.dsa" do
  to "#{node['round-three']['dir']}/shared/peoplesoft.dsa"
end
