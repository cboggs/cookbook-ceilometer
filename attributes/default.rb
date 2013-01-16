########################################################################
# Toggles - These can be overridden at the environment level
########################################################################

default["ceilometer"]["api_logdir"] = "/var/log/ceilometer-api"
default["ceilometer"]["branch"] = node["package-component"]
default["ceilometer"]["conf"] = "/etc/ceilometer/ceilometer.conf"
default["ceilometer"]["database_connection"] = nil
default["ceilometer"]["dependent_pkgs"] = ['libxslt-dev', 'libxml2-dev']
default["ceilometer"]["install_dir"] = '/opt/ceilometer'
