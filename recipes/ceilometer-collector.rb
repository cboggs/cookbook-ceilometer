#
# Cookbook Name:: ceilometer
# Recipe:: ceilometer-collector
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

::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

include_recipe "ceilometer::ceilometer-db-setup"
include_recipe "ceilometer::ceilometer-common"

#release = node["package_component"] || 'folsom'

db_scheme = node["ceilometer"]["db"]["scheme"]
if db_scheme == 'mongodb'
  include_recipe "mongodb::10gen_repo" 
  include_recipe "mongodb" 

  service "mongod" do
    action [ :enable, :start ]
  end

  case node['platform']
  when 'ubuntu'
    package 'python-pymongo'
  when 'centos'
    package 'pymongo'
  end

end

node['ceilometer']['packages']['collector'].each do |pkg|
  package pkg
end

service "#{node['ceilometer']['services']['collector']}" do
  action [ :enable, :start ]
end

#case node['platform']
#when 'ubuntu'
#  cookbook_file "/etc/init/ceilometer-collector.conf" do
#    source "init_ceilometer-collector.conf"
#    mode 0644
#    owner node["nova"]["user"]
#    group node["nova"]["group"]
#  end
#
#  link "/etc/init.d/ceilometer-collector" do
#    to '/lib/init/upstart-job'
#    action :create
#  end
#else
  # need to implement
#end

# db migration
#ceilometer_conf = node["ceilometer"]["conf"]
#install_dir = node["ceilometer"]["install_dir"]
#bash "migration" do
#  if File.exists?("#{install_dir}/tools/dbsync")
#    break if db_scheme == 'mongodb'
#    code <<-EOF
#      #{install_dir}/tools/dbsync --config-file=#{ceilometer_conf}
#    EOF
#  else
#    code <<-EOF
#      ceilometer-dbsync --config-file=#{ceilometer_conf}
#    EOF
#  end
#end

#bindir = '/usr/local/bin'
#conf_switch = "--config-file #{ceilometer_conf}"

#service "ceilometer-collector" do
#  service_name "ceilometer-collector"
#  case  node['platform']
#  when 'ubuntu'
#    action [:enable, :start]
#  else
#    action [:start]
#    start_command "nohup #{bindir}/ceilometer-collector #{conf_switch} &"
#    stop_command "pkill -f ceilometer-collector"
#  end
#end
