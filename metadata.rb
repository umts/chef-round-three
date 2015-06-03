name             'round-three'
maintainer       'UMass Transit Service'
maintainer_email 'transit-it@admin.umass.edu'
license          'mit'
description      'Installs/Configures round-three'
long_description 'Installs/Configures round-three'
version          '1.0.0'

depends 'ruby-install', '~> 0.2.0'
depends 'apache2', '~> 3.0.1'
depends 'passenger', '~> 0.1.0'

supports 'ubuntu'
supports 'centos', '>= 7'
