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

include_recipe "ceilometer::ceilometer-common"

release = node["package_component"] || 'folsom'

database_connection = node["ceilometer"]["database_connection"]
if database_connection &&  database_connection.match(/^mongodb:\/\//)
  mongodb_flag = True
else
  mongodb_flag = nil
end

include_recipe "mongodb" if mongodb_flag

# db migration
ceilometer_conf = node["ceilometer"]["conf"]
install_dir = node["ceilometer"]["install_dir"]
bash "migration" do
  case release
  when 'folsom'
    break if mongodb_flag
    code <<-EOF
      #{install_dir}/tools/dbsync --config-file=#{ceilometer_conf}
    EOF
  else
    code <<-EOF
      ceilometer-dbsync --config-file=#{ceilometer_conf}
    EOF
  end
end

bindir = '/usr/local/bin'
conf_switch = "--config-file #{ceilometer_conf}"

service "ceilometer-collector" do
  service_name "ceilometer-collector"
  action [:start]
  start_command "nohup #{bindir}/ceilometer-collector #{conf_switch} &"
  stop_command "pkill -f ceilometer-collector"
end
