A set of scripts to install HubZero
===================================

This project is a set of scripts for installing [HubZero](https://hubzero.org) onto a virtual machine
running on the Nectar cloud, using [Heat](https://support.rc.nectar.org.au/docs/heat)

# NB: This is a work in progress! #

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
heat stack-create --template-file=heat/hubzero.yaml --environment-file=heat/environment.yaml hubzero_1_3

# wait for a while...
# TODO: email the user when the install is complete...
```

