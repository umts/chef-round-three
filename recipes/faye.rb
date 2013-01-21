#
# Cookbook Name:: round-three
# Recipe:: faye
#
# Copyright 2012, UMass Transit Service
#
# All rights reserved - Do Not Redistribute
#

%w{log pids}.each do |dir|
  directory "#{node['round-three']['dir']}/shared/#{dir}" do
    owner "root"
    group "root"
    mode "0755"
    action :create
  end
end

directory "#{node['round-three']['dir']}/current/tmp/pids" do
  owner "root"
  group "root"
  mode "0755"
  action :create
  recursive true
end

link "#{node['round-three']['dir']}/current/log" do
  to "#{node['round-three']['dir']}/shared/log"
end

link "#{node['round-three']['dir']}/current/config/faye.yml" do
  to "#{node['round-three']['dir']}/shared/faye.yml"
end

template node['round-three']['dir']+"/shared/faye.yml" do
  source "faye.yml.erb"
  mode "0755"
  variables(
    :dir => node['round-three']['dir']+"/current/",
    :port => 9292,
    :environment => node.chef_environment,
    :rackup => "private_pub.ru",
    :ssl_key => "/etc/ssl/transit-demo.admin.umass.edu.key",
    :ssl_cert => "/etc/ssl/transit-demo.admin.umass.edu_combined.cert"
  )
  notifies :restart, "service[faye]"
end

template "/etc/init.d/faye" do
  source "faye-initd.erb"
  mode   "0755"
  variables(
    :round_three_dir => node['round-three']['dir']+"/current",
    :config => node['round-three']['dir']+"/current/config/faye.yml",
    :bundler => node['rbenv']['root_path']+"/shims/bundle"
  )
end

service "faye" do
  supports :restart => true
  action [:enable, :start]
  pattern 'thin server \((?:\d{1,3}\.){3}\d{1,3}:9292\)'
end
