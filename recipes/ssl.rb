#
# Cookbook Name:: round-three
# Recipe:: ssl
#
# Copyright 2012, UMass Transit Service
#
# All rights reserved - Do Not Redistribute
#
include_recipe "ssl"
include_recipe "apache2::mod_ssl"

domain = "umasstransit.org"

ssl_certificate "umasstransit" do
  name        domain
  ca          "GoDaddy"
  key         "/etc/ssl/#{domain}.key"
  certificate "/etc/ssl/#{domain}.cert"
  days        5*365
end

cookbook_file "/etc/ssl/go-daddy-intermediate.cert" do
  mode '0644'
  notifies :restart, 'service[apache2]'
end

execute "create_ssl_bundle" do
  cert = "/etc/ssl/#{domain}.cert"
  interm = "/etc/ssl/go-daddy-intermediate.cert"
  combo = "/etc/ssl/#{domain}_combined.cert"

  command "cat #{cert} #{interm} > #{combo}"
  only_if { ::File.exists?(cert) && ::File.exists?(interm) }
end

web_app "round-three-ssl" do
  template        "round-three-ssl.conf.erb"
  docroot         "#{node['round-three']['dir']}/current/public"
  server_name     "round-three.#{node['domain']}"
  server_aliases  ["umasstransit.org", "transit-demo.admin.umass.edu"]
  log_dir         node['apache']['log_dir']
  rails_env       node.chef_environment =~ /_default/ ? "production" : node.chef_environment
  ssl_key         "/etc/ssl/#{domain}.key"
  ssl_certificate "/etc/ssl/#{domain}.cert"
  ssl_chain       "/etc/ssl/in-common-intermediate.cert"
  redirects       node['round-three']['redirects']
end

apache_site "round-three.conf" do
  enable false
end

