#
# Cookbook Name:: round-three
# Recipe:: developer_logins
#
# Copyright 2012, UMass Transit Service
#
# All rights reserved - Do Not Redistribute
#
users_manage "developers" do
  group_id 2400
  action [ :remove, :create ]
end

node.normal['authorization']['sudo']['groups'] = node['authorization']['sudo']['groups'] + ['developers']

group node['round-three']['group'] do
  append true
  members search(:users, "groups:developers AND NOT action:remove").map {|sa| sa.id}
end
