set['passenger']['version'] = "3.0.15"
set['passenger']['root_path']   = "#{languages['ruby']['gems_dir']}/gems/passenger-#{passenger['version']}"
set['passenger']['module_path'] = "#{passenger['root_path']}/ext/apache2/mod_passenger.so"

set['shibboleth']['idp'] = "https://webauth.oit.umass.edu"

default['round-three']['dir'] = "/srv/round-three"
default['round-three']['faye-port'] = 9292
default['round-three']['group'] = 'deploy'

default['round-three']['db-dump-dir'] = '/var/db-dump'

default['round-three']['strict-host-redirect'] = true

default['round-three']['redirects'] = {'st-wiki' => 'http://st-wiki.umasstransit.org',
                                       'wiki' => 'https://transit-app1.admin.umass.edu/wiki'}

default['round-three']['exempted-paths'] = %w{exports}
