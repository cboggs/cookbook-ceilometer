########################################################################
# Toggles - These can be overridden at the environment level
########################################################################

default["ceilometer"]["api_logdir"] = "/var/log/ceilometer-api"
default["ceilometer"]["branch"] = 'stable/folsom'
default["ceilometer"]["repo"] = 'https://github.com/openstack/ceilometer.git'
default["ceilometer"]["conf"] = "/etc/ceilometer/ceilometer.conf"
default["ceilometer"]["db"]["host"] = nil
default["ceilometer"]["db"]["name"] = 'ceilometer'
default["ceilometer"]["db"]["port"] = nil
default["ceilometer"]["db"]["scheme"] = 'mysql'
default["ceilometer"]["db"]["username"] = 'ceilometer'
default["ceilometer"]["dependent_pkgs"] = ['libxslt-dev', 'libxml2-dev']
default["ceilometer"]["install_dir"] = '/opt/ceilometer'
default["ceilometer"]["periodic_interval"] = 60
