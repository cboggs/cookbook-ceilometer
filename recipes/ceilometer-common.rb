#
# Cookbook Name:: ceilometer
# Recipe:: ceilometer-common
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

include_recipe "nova::nova-common"
include_recipe "python::pip"

branch = node["ceilometer"]["branch"] || 'folsom'

dependent_packages = node["ceilometer"]["dependent_packages"]
dependent_packages.each do |pkg|
  package pkg do
    action :upgrade
  end
end

api_logdir = node["ceilometer"]["api_logdir"]
nova_owner = node["nova"]["user"]
nova_group = node["nova"]["group"]

directory api_logdir do
  owner nova_owner
  group nova_group
  mode  00755
  recursive true

  action :create
end

#  Cleanup old installation
python_pip "ceilometer" do
  action :remove
end

bin_names = ['agent-compute', 'agent-central', 'collector', 'dbsync', 'api']
bin_names.each do |bin_name|
  file "ceilometer-#{bin_name}" do
    action :delete
  end
end

# install source
install_dir = node["ceilometer"]["install_dir"]

directory install_dir do
  owner nova_owner
  group nova_group
  mode  00755
  recursive true

  action :create
end

git install_dir do
  repo "git://github.com/openstack/ceilometer.git"
  reference branch 
  action :sync
end

python_pip install_dir do
  action :install
end

# create conf
conf = node["ceilometer"]["conf"]
directory "/etc/ceilometer" do
  owner nova_owner
  group nova_group
  mode  00755

  action :create
end

nova_setup_info = get_settings_by_role("nova-setup", "nova")

# nova mysql
mysql_info = get_access_endpoint("mysql-master", "mysql", "db")
mysql_host = mysql_info["host"]
mysql_port = mysql_info["port"]
mysql_user = node["nova"]["db"]["username"]
mysql_password = nova_setup_info["db"]["password"]
mysql_dbname = node["nova"]["db"]["name"] || 'nova'
mysql_uri = "mysql://#{mysql_user}:#{mysql_password}@#{mysql_host}:#{mysql_port}/#{mysql_dbname}"

# ceilometer db
database_connection = node["ceilometer"]["database_connection"]

rabbit_info = get_access_endpoint("rabbitmq-server", "rabbitmq", "queue")
keystone = get_settings_by_role("keystone", "keystone")
ks_admin_endpoint = get_access_endpoint("keystone", "keystone", "admin-api")

Chef::Log.debug("nova::nova-common:rabbit_info|#{rabbit_info}")
Chef::Log.debug("nova::nova-common:keystone|#{keystone}")
Chef::Log.debug("nova::nova-common:ks_admin_endpoint|#{ks_admin_endpoint.to_s}")

template "/etc/ceilometer/ceilometer.conf" do
  source "ceilometer.conf.erb"
  owner  nova_owner
  group  nova_group
  mode   00644
  variables(
    :database_connection => database_connection,
    :sql_connection => mysql_uri,
    :rabbit_ipaddress => rabbit_info["host"],
    :rabbit_port => rabbit_info["port"],
    :user => keystone["admin_user"],
    :tenant => keystone["users"][keystone["admin_user"]]["default_tenant"],
    :password => keystone["users"][keystone["admin_user"]]["password"],
    :ks_admin_endpoint => ks_admin_endpoint["uri"]
  )
end

cookbook_file "/etc/ceilometer/policy.json" do
  source "policy.json"
  mode 0755
  owner nova_owner
  group nova_group
end
