A set of scripts to install HubZero
===================================

This project contains a set of scripts for installing [HubZero](https://hubzero.org) onto a virtual machine
running on the Nectar cloud, using [Heat](https://support.rc.nectar.org.au/docs/heat)

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
# These parameters and the defaults are described in the heat template, heat/hubzero.yaml
vi heat/environment.yaml

# Launch the heat template
heat stack-create --template-file=heat/hubzero.yaml --environment-file=heat/environment.yaml a_suitable_name

# wait for a while...
```

The installation is a two phase one. First Heat sets up and configures the required infrastructure. Then it hands
over to a set of Puppet scripts on the instance that install and manage the required software. Hence the installation
is not complete until the Puppet scripts have finished executing.

Once complete, the install will send email to the postmaster address given in the environment template.
Typically it will take 15 minutes (sometimes a lot longer) to run through the installation.

The Heat template has on its stack output page the url's to connect to the instance and a sample ssh connection string.

Once completed, the passwords and users created by the hub zero installation can be found in the file:

```bash
/etc/hubzero.secrets
```

To login to the site as admin, use the password from the hubzero.secrets file for the JOOMLA-ADMIN, but with the
user name 'admin'

If installing version 1.1, once the installation is complete, go to the administrator section of your site
(/administrator), go to Site->Maintenance->LDAP and press the Export Users and Export Groups buttons
in order to export all the CMS users and groups

Tasks still to be done:
- Do we need to move the users home directories to the larger mounted transient storage?
- The submit package is not yet added to the installation. Is it needed?
- The external DNS entry for the site and any matching records need to be set up manually.
- What about log files. Should we rotate them? Do we backup them up as well?
- What to do about backup files that are older than, say  7 days?
http://www.linuxquestions.org/questions/linux-general-1/bash-script-to-remove-files-older-than-3-days-462290/

Known issues:
- The LDAP installation on version 1.1 returns an error: this needs investigation. See the open-ldap module for more.
  We are not going to investigate this further as we are not targeting 1.1.
- The email doesn't send mail successfully to all sites, as some sites, such as google, don't trust it (not surprising).
- Also, not all NeCTAR nodes seem to allow e-mail to flow out.