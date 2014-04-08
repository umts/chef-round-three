default['round-three']['ruby_version'] = '2.1.0'
default['round-three']['repository'] = "git@github.com:umts/round-three.git"
default['round-three']['revision'] = 'HEAD'

default['round-three']['dir'] = "/srv/round-three"
default['round-three']['group'] = 'deploy'

default['round-three']['faye-port'] = 9292

default['round-three']['db-dump-dir'] = '/var/db-dump'

default['round-three']['strict-host-redirect'] = true
default['round-three']['redirects'] = {'st-wiki' => 'http://st-wiki.umasstransit.org',
                                       'wiki' => 'https://transit-app1.admin.umass.edu/wiki'}
default['round-three']['exempted-paths'] = %w{exports}

#set['passenger']['version'] = "3.0.15"
set['passenger']['ruby_bin'] = "/opt/rbenv/versions/#{node['round-three']['ruby_version']}/bin/ruby"
set['passenger']['root_path'] = "/opt/rbenv/versions/#{node['round-three']['ruby_version']}/lib/ruby/gems/#{node['round-three']['ruby_version']}/gems/passenger-#{passenger['version']}"
set['passenger']['module_path'] = "#{passenger['root_path']}/#{Chef::Recipe::PassengerConfig.build_directory_for_version(passenger['version'])}/apache2/mod_passenger.so"

set['shibboleth']['idp'] = "https://webauth.oit.umass.edu"

