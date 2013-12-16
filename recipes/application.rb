#
# Cookbook Name:: round-three
# Recipe:: application
#
# Copyright 2012, UMass Transit Service
#
# All rights reserved - Do Not Redistribute
#
require_recipe "apache2"
require_recipe "git"
require_recipe "xml"

round_three_secrets = Chef::EncryptedDataBagItem.load("apps", "round-three")
rev = "HEAD"

rbenv_gem "bundler"
# Install the gem here, so the "passenger-install-apache-module" gets rehashed
# It will actually be installed by the sub-resource below
rbenv_gem "passenger" do
  version node['passenger']['version']
end

group node['round-three']['group'] do
  append true
  members search(:users, "groups:sysadmin AND NOT action:remove").map {|sa| sa.id}
end

application "round-three" do
  path  node['round-three']['dir']
  owner node['apache']['user']
  group node['round-three']['group']

  repository "git@github.com:umts/round-three.git"
  revision rev
  deploy_key round_three_secrets['deploy_key']

  rollback_on_error false

  purge_before_symlink %w{log tmp/pids public/system public/user_pictures public/documents public/exports}
  create_dirs_before_symlink %w{tmp public config}
  symlinks( { "system" => "public/system",
              "pids" => "tmp/pids",
              "log" => "log",
              "user_pictures" => "public/user_pictures",
              "documents" => "public/documents",
              "exports" => "public/exports"
  })

  rails do
    bundler true
    bundler_deployment false
    database do
      adapter 'postgresql'
      host    'localhost'
      database 'round_three_production'
      username 'round_three'
      password round_three_secrets['passwords']['database']
    end
  end

  passenger_apache2 do
    server_aliases ["umasstransit.org", "transit-demo.admin.umass.edu"]
  end

  #migrate true

  after_restart do
    execute "whenever" do
      cwd "#{node['round-three']['dir']}/current/"
      command "#{node['rbenv']['root_path']}/shims/bundle exec whenever --update-crontab round-three"
      action :run
    end

    #sure would be nice if the application resource would allow this directly.
    execute "fix-rt-permissions" do
      command "chmod -R g=u #{node['round-three']['dir']}"
      action :run
    end

    execute "create-revision-file" do
      cwd "#{node['round-three']['dir']}/current/"
      command "git rev-parse #{rev} > REVISION"
    end
  end
end

