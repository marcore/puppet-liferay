# == Resource: liferay::plugin
#
# === Parameters
#
# [*instance*]  The instance this plugin should be installed in (see liferay::instance). 
# [*source*] The source of the file to install (.war).
# [*target*] The target of the file to install (.war), defaults to $name.
#
# === Variables
#
# === Examples
#
# This will install the marketplace plugin in a an instance named liferay_com.
# liferay::instance { 'liferay_com':
#
#   version     => '6.1.1',
#}
#
# This will install the latest available Liferay CE in a tomcat instance called tomcat_1.
# liferay::instance { 'liferay_com':
#   instance    => 'tomcat_1',
#   version     => 'LATEST',
#}
#
# === Authors
#
# Sander Bilo <sander@proteon.nl>
#
# === Copyright
#
# Copyright 2013 Proteon.
#
define liferay::plugin ($instance, $source, $target = $name) {
    include ::tomcat
    
    if (!defined(File["${tomcat::params::home}/${instance}/.plugins"])) {
        file { "${tomcat::params::home}/${instance}/.plugins":
            ensure => directory,
            owner  => 'root',
            group  => 'root',
        }
    }

    file { "${tomcat::params::home}/${instance}/.plugins/${target}.war":
        source => $source,
        owner  => 'root',
        group  => 'root',
        notify => Exec["${tomcat::params::home}/${instance}/deploy/${target}.war"],
    }

    exec { "${tomcat::params::home}/${instance}/deploy/${target}.war":
        command     => "sudo -u ${instance} cp .plugins/${target}.war deploy/",
        refreshonly => true,
    }
}