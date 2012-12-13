Description
===========

Installs the Openstack ceilometer service from pip packages.

Requirements
============

Chef 0.10.0 or higher required (for Chef environment use).

Platforms
--------

* Ubuntu-12.04
* Fedora-17

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

ceilometer-api
---
- Installs the ceilometer-api service startup script

ceilometer-collector
---
- Installs the ceilometer-collector service startup script


ceilometer-agent-compute
---
- Installs the ceilometer-agent-compute service startup script


ceilometer-agent-central
---
- Installs the ceilometer-agent-central service startup script


Attributes
==========

* `ceilometer["database_connection"] - Database backend for ceilometer

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
