#
# Cookbook Name:: ceilometer
# Recipe:: ceilometer-agent-compute
#
# Copyright 2012, AT&T
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "ceilometer::ceilometer-common"

node['ceilometer']['packages']['compute'].each do |pkg|
  package pkg
end

service "#{node['ceilometer']['services']['compute']}" do
  action [ :enable, :start ]
end

#case node['platform']
#when 'ubuntu'
#  cookbook_file "/etc/init/ceilometer-agent-compute.conf" do
#    source "init_ceilometer-agent-compute.conf"
#    mode 0644
#    owner node["nova"]["user"]
#    group node["nova"]["group"]
#  end
#
#  link "/etc/init.d/ceilometer-agent-compute" do
#    to '/lib/init/upstart-job'
#    action :create
#  end
#else
#  # need to implement
#end

#bindir = '/usr/local/bin'
#ceilometer_conf = node["ceilometer"]["conf"]
#conf_switch = "--config-file #{ceilometer_conf}"

#service "ceilometer-agent-compute" do
#  service_name "ceilometer-agent-compute"
#  case  node['platform']
#  when 'ubuntu'
#    action [:enable, :start]
#  else
#    action [:start]
#    start_command "nohup #{bindir}/ceilometer-agent-compute #{conf_switch} &"
#    stop_command "pkill -f ceilometer-agent-compute"
#  end
#end
