########################################################################
# Toggles - These can be overridden at the environment level
########################################################################

default["ceilometer"]["api_logdir"] = "/var/log/ceilometer-api"
default["ceilometer"]["logdir"] = "/var/log/ceilometer"
default["ceilometer"]["conf"] = "/etc/ceilometer/ceilometer.conf"
default["ceilometer"]["db"]["host"] = nil
default["ceilometer"]["db"]["name"] = 'ceilometer'
default["ceilometer"]["db"]["port"] = nil
default["ceilometer"]["db"]["scheme"] = 'mysql'
default["ceilometer"]["db"]["username"] = 'ceilometer'
default["ceilometer"]["install_dir"] = '/opt/ceilometer'
default["ceilometer"]["periodic_interval"] = 60
default["ceilometer"]["user"] = 'ceilometer'
default["ceilometer"]["group"] = 'ceilometer'

case platform
when "centos"
  default["ceilometer"]["packages"] = {
      "common" => ['openstack-ceilometer-common'],
      "central" => ['openstack-ceilometer-central'],
      "api" => ['openstack-ceilometer-api'],
      "compute" => ['openstack-ceilometer-compute'],
      "collector" => ['openstack-ceilometer-collector']  
    }
when "suse"
  default["ceilometer"]["packages"] = {
    "common_packages" => ['openstack-ceilometer'],
    "agent_central_packages" => ['openstack-ceilometer-agent-central'],
    "agent_compute_packages" => ['openstack-ceilometer-agent-compute'],
    "api_packages" => ['openstack-ceilometer-api'],
    "collector_packages" => ['openstack-ceilometer-collector'],
  }
when "ubuntu"
  default["openstack"]["metering"]["platform"] = {
    "common_packages" => ['ceilometer-common'],
    "agent_central_packages" => ['ceilometer-agent-central'],
    "agent_compute_packages" => ['ceilometer-agent-compute'],
    "api_packages" => ['ceilometer-api'],
    "collector_packages" => ['ceilometer-collector'],
  }
end

default["ceilometer"]["services"] = {
      "common" => 'openstack-ceilometer-collector',
      "central" => 'openstack-ceilometer-central',
      "api" => 'openstack-ceilometer-api',
      "compute" => 'openstack-ceilometer-compute',
      "collector" => 'openstack-ceilometer-collector'
}
