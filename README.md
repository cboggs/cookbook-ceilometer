Description
===========

Cookbook to be used with rcbpops chef-repo (https://github.com/rcbops/chef-cookbooks) only, as it relies on attributes from pre-existing recipes, envs and roles.
Installs the Openstack ceilometer service from github source (https://github.com/openstack/ceilometer.git).

Requirements
============

Chef 0.10.0 or higher required (for Chef environment use).

Platforms
---------

* Ubuntu-12.04

Cookbooks
---------

The following cookbooks are dependencies:

* mongodb
* mysql
* nova
* python

Resources/Providers
===================

None


Recipes
=======

ceilometer-common
----
- Installs the ceilometer code base, conf and dependencies

ceilometer-db-setup
---
- Creates Ceilometer MySQL db, user, password via osops-utils and runs db migration

ceilometer-api
---
- Controls ceilometer-api start/stop

ceilometer-collector
---
- Controls ceilometer-collector start/stop

ceilometer-agent-compute
---
- Controls ceilometer-agent-compute start/stop


ceilometer-agent-central
---
- Controls ceilometer-agent-central start/stop


Attributes
==========
Some attributes are auto-populated from other recipes when used with rcbpops chef-repo.
Ceilometer configurable attributes can be overridden via environments profile:

* `node["ceilometer"]["api_logdir"]` - Directory location of ceilometer-api logfiles
(Default: "/var/log/ceilometer-api")
* `default["ceilometer"]["branch"]` - Ceilometer branch to checkout for install
(Default: 'stable/folsom')
* `default["ceilometer"]["conf"]` - Absolute path designating ceilometer config file
(Default: "/etc/ceilometer/ceilometer.conf")
* `default["ceilometer"]["db"]["name"]` - Ceilometer database name
(Default: 'ceilometer')
* `default["ceilometer"]["db"]["scheme"]` - Ceilometer database scheme
(Default: 'mysql')
* `default["ceilometer"]["db"]["username"]` - Ceilometer database user name
(Default: 'ceilometer')
* `default["ceilometer"]["dependent_pkgs"]` - Native OS package dependencies
(Default: ['libxslt-dev', 'libxml2-dev'])
* `default["ceilometer"]["install_dir"]` - Where to install the ceilometer source code
(Default'/opt/ceilometer')


Roles
=====


Templates
=====
* `ceilometer.conf` - configuration file for ceilometer


License and Author
==================

Author:: John Tran (<jhtran@att.com>)  

Copyright 2012, AT&T

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
