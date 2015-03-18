A Set of Scripts to Install HubZero
===================================

Intent
------
This project contains a set of scripts for installing [HubZero](https://hubzero.org) onto a virtual machine
running on the Nectar cloud, using [Heat](https://support.rc.nectar.org.au/docs/heat).

Prerequisites
-------------

1. Australian Access Federation (AAF) credentials. In other words a computer account with an Australian University.
2. A NeCTAR (Openstack) account providing access to the Dashboard and an associated project.
3. A named keypair provided by the NeCTAR Dashboard.
4. A generated password provided by the NeCTAR Dashboard.
5. A domain name provided via some authority such as DynDNS, etc..
6. A Python installation with the pip package manager and dependency building tools such as gcc.
7. The relevant OpenStack utilities such as the Heat command line client.
8. Some facility with a unix-style operating system.

Installation
------------

The installation of HubZero is performed by executing a bash command from
the local machine that executes the heat client with command line parameters
that refer to a heat template file and an environment file (aka scripts).

To use these scripts you need to have the Heat command line client installed. Instructions for installing and using
the command line tools on the NeCTAR cloud [are found here](https://support.rc.nectar.org.au/docs/installing-command-line-tools).

You also need to know a little bit about [Heat](https://support.rc.nectar.org.au/docs/heat) if you are
going to customize the default paramater values...

Once the command line tools are installed, the following steps will get you up and running:

```bash
# Clone the repository
git clone https://github.com/MartinPaulo/puppet_hub_zero.git

# Copy the environment template in the heat subdirectory, say to a file named 'environment.yaml'
cp heat/environment_template.yaml heat/environment.yaml

# Edit the file and provide any required parameters.
# Also put in replacement values for any of the default parameter values that are not acceptable.
# Refer to the prerequisites above to source the parameters required.
# These parameters and the defaults are described in the heat template, heat/hubzero.yaml
vi heat/environment.yaml

# Launch the heat template
heat stack-create --template-file=heat/hubzero.yaml --environment-file=heat/environment.yaml a_suitable_name

# wait for a while...
```

The installation is a two phase one. First Heat sets up and configures the required VM infrastructure. Then it hands
over to a set of Puppet scripts on the instance that install and manage the required software. Hence the installation
is not complete until the Puppet scripts have finished executing.

The Heat template, once completed, publishes to NeCTAR Dashboard stack output page
the url's needed to connect to the instance and a sample ssh connection string.

While the execution and completion of the heat template provides some feedback,
the execution of Puppet proceeds behind the scenes. 
To obtain feedback on Puppet execution login to the target VM using the ssh connection string
and tail the OpenStack log files.

Once the entire installation is complete, an email will be sent to the postmaster address given in the environment template.
Typically it will take 15 minutes (sometimes a lot longer) to run through the installation.

Once the installation has completed, perform an ssh login to the virtual machine you have just created.
Then the passwords and users created by the hub zero installation can be found in the file:

```bash
/etc/hubzero.secrets
```

Configuration
-------------

HubZero provides a web-based administrator/configuration interface via the Joomla web application.
Joomla is a Content Management System (CMS) that provides user and group management.

To login to the web site as admin, use the password from the hubzero.secrets file for the JOOMLA-ADMIN, but with the
user name 'admin'

If installing version 1.1, once the installation is complete, go to the administrator section of your site
(/administrator), go to Site->Maintenance->LDAP and press the Export Users and Export Groups buttons
in order to export all the CMS users and groups

Still to be resolved:
- Do we need to move some of the data directories to the larger mounted transient storage?
- The submit package is not yet added to the installation. Is it needed?
- What about log files. Should we rotate them? Do we backup them up as well?

Known issues:
- The external DNS entry for the site and any matching records need to be set up manually.
- The LDAP installation on version 1.1 returns an error: this needs investigation. See the open-ldap module for more.
  We are not going to investigate this further as we are not targeting 1.1.
- The email doesn't send mail successfully to all sites, as some sites, such as google, don't trust it (not surprising).
- Also, not all NeCTAR nodes seem to allow e-mail to flow out.