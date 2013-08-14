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

require 'uri'

include_recipe "nova::nova-common"
#include_recipe "python::pip"

#branch = node["ceilometer"]["branch"]
#git_repo = node["ceilometer"]["repo"]

#dependent_pkgs = node["ceilometer"]["dependent_pkgs"]
#dependent_pkgs.each do |pkg|
#  package pkg do
#    action :upgrade
#  end
#end

package "git"

node['ceilometer']['packages']['common'].each do |pkg|
  package pkg
end

logdir = node['ceilometer']['logdir']
ceilometer_owner = node['ceilometer']['user']
ceilometer_group = node['ceilometer']['group']

directory logdir do
  owner ceilometer_owner
  group ceilometer_group
  mode  00755
  recursive true
  action :create
end

#  Cleanup old installation
#python_pip "ceilometer" do
#  action :remove
#end

#bin_names = ['agent-compute', 'agent-central', 'collector', 'dbsync', 'api']
#bin_names.each do |bin_name|
#  file "ceilometer-#{bin_name}" do
#    action :delete
#  end
#end

# install source
#install_dir = node["ceilometer"]["install_dir"]

#directory install_dir do
  #owner ceilometer_owner
  #group ceilometer_group
  #mode  00755
  #recursive true

  #action :create
#end

#git install_dir do
  #repo git_repo
  #reference branch 
  #action :sync
#end

#python_pip install_dir do
  #action :install
#end

# create conf
conf = node["ceilometer"]["conf"]

directory "/etc/ceilometer" do
  owner ceilometer_owner
  group ceilometer_group
  mode  00755
  action :create
end

nova_setup_info = get_settings_by_role("nova-setup", "nova")

# nova db
nova_db_info = get_access_endpoint("mysql-master", "mysql", "db")
nova_db_host = nova_db_info["host"]
nova_db_port = nova_db_info["port"]
nova_db_user = node["nova"]["db"]["username"]
nova_db_password = nova_setup_info["db"]["password"]
nova_db_name = node["nova"]["db"]["name"] || 'nova'
nova_db_uri = URI::Generic.build({:host => nova_db_host,
                             :port => nova_db_port,
                             :scheme => 'mysql',
                             :userinfo => "#{nova_db_user}:#{nova_db_password}",
                             :path => "/#{nova_db_name}"
                            })

# ceilometer db
db_host = node["ceilometer"]["db"]["host"]
db_scheme = node["ceilometer"]["db"]["scheme"]
unless db_host
  db_host = db_scheme == 'mongodb' ? 'localhost' : nova_db_host
end
db_name = node["ceilometer"]["db"]["name"]
db_user = node["ceilometer"]["db"]["username"]
db_port = node["ceilometer"]["db"]["port"]
db_password = node["ceilometer"]["db"]["password"]
db_query = db_scheme == 'mysql' ? 'charset=utf8' : nil
db_uri = URI::Generic.build({:host => db_host,
                             :port => db_port,
                             :scheme => db_scheme,
                             :userinfo => "#{db_user}:#{db_password}",
                             :path => "/#{db_name}",
                             :query => db_query
                            })

rabbit_info = get_access_endpoint("rabbitmq-server", "rabbitmq", "queue")
keystone = get_settings_by_role("keystone", "keystone")
ks_admin_endpoint = get_access_endpoint("keystone", "keystone", "admin-api")

Chef::Log.debug("nova::nova-common:rabbit_info|#{rabbit_info}")
Chef::Log.debug("nova::nova-common:keystone|#{keystone}")
Chef::Log.debug("nova::nova-common:ks_admin_endpoint|#{ks_admin_endpoint.to_s}")

template "/etc/ceilometer/ceilometer.conf" do
  source "ceilometer.conf.erb"
  owner  ceilometer_owner
  group  ceilometer_group
  mode   00644
  variables(
    :database_connection => db_uri.to_s,
    :sql_connection => nova_db_uri,
    :rabbit_ipaddress => rabbit_info["host"],
    :rabbit_port => rabbit_info["port"],
    :user => keystone["admin_user"],
    :tenant => keystone["users"][keystone["admin_user"]]["default_tenant"],
    :password => keystone["users"][keystone["admin_user"]]["password"],
    :ks_admin_endpoint => ks_admin_endpoint["uri"],
    :periodic_interval => node['ceilometer']['periodic_interval']
  )
end

cookbook_file "/etc/ceilometer/policy.json" do
  source "policy.json"
  mode 0755
  owner ceilometer_owner
  group ceilometer_group
end
