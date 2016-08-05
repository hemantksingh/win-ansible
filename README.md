# Overview
Manages a remote windows host using `winrm` through an Ubuntu ansible control server. Requirements:

* vagrant
* virtualbox

Control server uses ansible 2.1


## Setup servers

* `vagrant up`

## Configure Windows host

* `ansible-playbook iis.yml`  
