#
# Cookbook Name:: round-three
# Recipe:: db-dumps
#
# Copyright 2013, UMass Transit Service
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'rsnapshot::client'

round_three_secrets = Chef::EncryptedDataBagItem.load("apps", "round-three")

directory node['round-three']['db-dump-dir'] do
  owner 'root'
  mode '0700'
end

unless node.normal['rsnapshot']['client']['paths'].index(node['round-three']['db-dump-dir'])
  node.normal['rsnapshot']['client']['paths'] << node['round-three']['db-dump-dir']
end

# Need a .pgpass file in order for pg_dump to log-in.  This shouldn't be too big
# of a security hole.  Anyone with root access to the server can also just read
# this password in plaintext in the database.yml file.
file '/root/.pgpass' do
  mode 0600
  owner 'root'
  #hostname:port:database:username:password
  content "127.0.0.1:*:round_three_production:round_three:#{round_three_secrets['passwords']['database']}"
end

# This mirors the logic in the cron.d file that rsnapshot::server uses
server = search(:node, "role:#{node['rsnapshot']['server_role']}").first
retain_hourly = server['rsnapshot']['server']['retain']['hourly'].to_i

retain_hourly.times do |i|
  h = ((24 / retain_hourly) * i + 3) % 24
  cron "dump-pg-db-#{h}30" do
    hour h
    minute 30
    command <<-EOS.gsub(/\n */, ' ')
      pg_dump --host=127.0.0.1
              --username=round_three
              --no-password
              --file=#{node['round-three']['db-dump-dir']}/round-three.pg
              --format=custom round_three_production
    EOS
  end
end
