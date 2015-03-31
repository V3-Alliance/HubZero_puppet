# Heat Script Successful Deployment Checklist

##First Name:
##Last Name:
##Date:

Write either a ☑ ('yes') or ☒ ('no') into the Result column as you progress.

The scripts run as a two stage process.  The first stage uses Heat to create the required infrastructure. This stage 
executes quite quickly: ordinarily in a matter of minutes.

The second stage takes place on the created instance and uses Puppet to install and configure the required software. 
This stage can take up to an hour to complete...

Once the Puppet scripts have finished, they send an e-mail to the address entered for the postmaster and reboot the
server. At that point you can use this checklist to verify that the install went according to plan.

**NB:** The software is being installed into a node that supports the sending of email. The list of nodes that can be 
used is limited to the ones that we have found are able to support this requirement. Of course this can change :(

Once you've run through this checklist, if everything comes up '☑', then you know that you most likely have a successful 
install. If you have a '☒' anywhere, then some debugging is needed.

## Part 1: Validating the NeCTAR infrastructure

Enter the Values of the initial Parameter settings as used in the `environment.yml`, `hubzero.yml`  files and the 
Heat client command line:

| Parameter        | Value&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|
|------------------|--------------------------------------------|
|image             |                                            |
|flavor            |                                            |
|key               |                                            |
|availability_zone |                                            |
|tenancy_name      |                                            |
|email_postmaster  |                                            |
|hub_zero_version  |                                            |
|hostname          |                                            |
|nagiosserver      |                                            |
|nectar_user_id    |                                            |
|stack name        |                                            |


Once the Heat scripts have been launched from the command line, Heat responds with a table showing the id of the newly 
launched stack, its name, creation time, and its initial status of "CREATE_IN_PROGRESS".

### Test 1: Once built, does the stack pass Parameters through correctly?

After some time, all being well on the NeCTAR side, the status of the stack will become "CREATE_COMPLETE". At 
this point the command:

```bash
$ heat stack-show <stack name>
```

will show the Parameters of the stack. The <stack name> originates from the heat stack-create command line string and 
its default Value is typically hubzero_test.

Are the following Assertions true?

|Result | Assertion |
|-------|-----------|
|       |The Parameter image matches the Value entered above|
|       |The Parameter flavor matches the Value entered above|
|       |The Parameter key matches the Value entered above|
|       |The Parameter availability_zone matches the Value entered above|
|       |The Parameter tenancy_name matches the Value entered above|
|       |The Parameter email_postmaster matches the Value entered above|
|       |The Parameter hub_zero_version matches the Value entered above|
|       |The Parameter hostname matches the Value entered above|
|       |The Parameter nagiosserver matches the Value entered above|
|       |The Parameter nectar_user_id matches the Value entered above|
|       |The Parameter pgp_passphraze is hidden by checkmarks|
|       |The Parameter swift_password is hidden by checkmarks|

### Test 2: Once built, does the stack apply Parameters correctly? 

Navigate to the instances tab of the dashboard ([https://dashboard.rc.nectar.org.au/project/instances/](https://dashboard.rc.nectar.org.au/project/instances/)). There will be an instance, whose instance name starts with "<stack-name>-hubZero_instance-"

Select the instance link to see the instance information.

In this page are the following Assertions true?

|Result | Assertion |
|-------|-----------|
|       |The Parameter availability_zone matches (or is in) the Availability Zone Value in the Info section|
|       |The Parameter flavor matches the Flavor Value in the Specs section|
|       |The Parameter key matches the Key Name Value in the Meta section|
|       |The Parameter image matches  the Image Name Value in the Meta section|


### Test 3: Once built, does the stack have the correct outputs?

Navigate to the stacks tab of the dashboard ([https://dashboard.rc.nectar.org.au/project/stacks/](https://dashboard.rc.nectar.org.au/project/stacks/)). Select the link with the stack name. Then select the **Overview** tab of the stack.

Are the following Assertions true?

|Result | Assertion |
|-------|-----------|
|       |In the Outputs section of the page there is an output named instance_ssh|
|       |The instance_ssh Value has the Parameter key Value in it|


### Test 4: Once built, can the machine be accessed via ssh?

Open a command line terminal. Copy and paste the `instance_ssh` Value into it. If the selected key location does not 
match the one given in the command, edit the -i argument to match the location. Hit the enter key.

Is the following Assertion true?

|Result | Assertion |
|-------|-----------|
|       |The HubZero instance can be accessed via ssh|


## Part 2: Validating the installation

The subsequent run by Puppet will terminate with a reboot of the machine onto which the software is being installed. 

The Puppet run can take quite a while. If you’ve left your ssh shell open on the machine you will be logged out when 
the reboot occurs.

You will have to ssh into the machine again, and re-verify your certificate.

Once logged in become the root user:

```bash
$ sudo -i
```

### Test 5: Does the site notify the postmaster that the install is complete?

Once the install is complete, the puppet script will send email to the address listed in the email_postmaster Parameter.

|Result | Assertion |
|-------|-----------|
|       |The person in the email_postmaster Parameter received an email with the message heading "Install Progress"|
|       |The body of the message read “The install is complete! You can find your new hubzero site at:” followed by a url|


### Test 6: Is the site actually up?

|Result | Assertion |
|-------|-----------|
|       |When you click on the link in the body of the email notifying that the installation was complete, received by the postmaster, you are taken to a site with an untrusted ssl certificate.|

**Note:** on version 1.3 of HubZero you will be taken to an unsecured  landing page which does NOT produce the 
certificate warning. On clicking the "Jump to your HUB" button, then you will be taken to the secured admin page which 
will produce the untrusted ssl certificate warning.


### Test 7: Does mail flow to the postmaster correctly?

As root, in the ssh window, on the virtual machine, enter the command:

```bash
$ echo "This is a test message." | mail -s "Hello from hubzero" root@localhost
```

|Result | Assertion |
|-------|-----------|
|       |Some time later, the person in the email_postmaster Parameter will receive an email with the message heading "This is a test message"|


### Test 8: Can the admin log in?

You cannot log into the site successfully unless the web browser, the database, the ldap server and the application 
itself have all been installed and correctly configured.

As root, in the ssh window on the virtual machine, enter the command: 

```bash
$ less /etc/hubzero.secrets
```

In the window brought up, make a note of the `JOOMLA-ADMIN` Value.

Then open your browser onto the link that was contained in the email to the postmaster notifying him of the installs completion.

On that page, select the "Login" link.

**Note:** for HubZero version 1.3 click on the "Jump to your HUB" button at the bottom of the page. On the admin page that 
then appears, select the “Login” link.

In the Resultant login page enter the username "admin" and the `JOOMLA-ADMIN` Value as the password.

|Result | Assertion |
|-------|-----------|
|       |The admin login is successful. |


### Test 9: Does the machine have the correct hostname?

As root, in the ssh window on the virtual machine, enter the command:

```bash
$ echo $(hostname)
```

Is the following correct?

|Result | Assertion |
|-------|-----------|
|       |The Result returned is the Value of the hostname Parameter. |


### Test 10: Have the Duplicity template Parameters been correctly passed through?

As root, in the ssh window on the virtual machine, enter the command:

```bash
$ less /etc/nectar.secrets
```

The Resulting file will have its variables made up as follows:

|Result | Assertion |
|-------|-----------|
|       |The SWIFT_USERNAME variable Value is made by prepending the tenancy_name Parameter to the nectar_user_id Parameter, with a ‘:’ as the separator. |
|       |The SWIFT_PASSWORD variable Value is the Value of the swift_password Parameter. |
|       |The PASSPHRASE variable Value is the Value of the pgp_passphraze Parameter.|


### Test 11: Are the Duplicity settings secure?

As root, in the ssh window on the virtual machine, enter the commands:

```bash
$ exit
$ less /etc/nectar.secrets
```

The file should not be visible:

|Result | Assertion |
|-------|-----------|
|       |The attempt to view the file as a non root user Resulted in the error message: "/etc/nectar.secrets: Permission denied"|
