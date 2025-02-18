name              'java'
maintainer        'Sous Chefs'
maintainer_email  'help@sous-chefs.org'
license           'Apache-2.0'
description       'Recipes and resources for installing Java and managing certificates'
source_url        'https://github.com/sous-chefs/java'
issues_url        'https://github.com/sous-chefs/java/issues'
chef_version      '>= 15.0'
version           '8.6.0'

supports 'debian'
supports 'ubuntu'
supports 'centos'
supports 'redhat'
supports 'scientific'
supports 'fedora'
supports 'amazon'
supports 'oracle'
supports 'freebsd'
supports 'suse'
supports 'opensuseleap'

depends 'line'

attribute "java/install_jdk",
          :description => "Flag to skip installing jdk. Default: true",
          :type => 'string'
