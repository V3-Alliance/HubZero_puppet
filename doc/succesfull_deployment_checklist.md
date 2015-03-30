# Heat Script Successful Deployment Checklist

##First Name:
##Last Name:
##Date:

If working online you can copy either ☑ or ☒ and paste into the Result column as you progress.

The scripts run as a two stage process.  The first stage uses Heat to create the required infrastructure. This stage 
executes quite quickly: ordinarily in a matter of minutes.

The second stage takes place on the created instance and uses Puppet to install and configure the required software.

**NB:** The software is being installed into a node that supports the sending of email. The list of nodes that can be 
used is limited to the ones that we have found are able to support this requirement. Of course this can change :(

## Part 1: Validating the NeCTAR infrastructure

Enter the Values of the initial Parameter settings as used in the environment.yml, hubzero.yml  files and the Heat client command line:

<table>
  <tr style="background-color: #D3D3D3;">
    <td>Parameter</td>
    <td>Value</td>
  </tr>
  <tr>
    <td>image</td>
    <td></td>
  </tr>
  <tr>
    <td>flavor</td>
    <td></td>
  </tr>
  <tr>
    <td>key</td>
    <td></td>
  </tr>
  <tr>
    <td>availability_zone</td>
    <td></td>
  </tr>
  <tr>
    <td>tenancy_name</td>
    <td></td>
  </tr>
  <tr>
    <td>email_postmaster</td>
    <td></td>
  </tr>
  <tr>
    <td>hub_zero_version</td>
    <td></td>
  </tr>
  <tr>
    <td>hostname</td>
    <td></td>
  </tr>
  <tr>
    <td>nagiosserver</td>
    <td></td>
  </tr>
  <tr>
    <td>nectar_user_id</td>
    <td></td>
  </tr>
  <tr>
    <td>stack name</td>
    <td></td>
  </tr>
</table>


Once the Heat scripts have been launched from the command line, Heat responds with a table showing the id of the newly 
launched stack, its name, creation time, and its initial status of "CREATE_IN_PROGRESS".

### Test 1: Once built, does the stack pass Parameters through correctly?

After some time, all being well on the NeCTAR side, the status of the stack will become "CREATE_COMPLETE". At this point the command:

```bash
$ heat stack-show <stack name>
```

will show the Parameters of the stack. The <stack name> originates from the heat stack-create command line string and 
its default Value is typically hubzero_test.

Are the following Assertions true?

<table>
  <tr>
    <td>Result</td>
    <td>Assertion</td>
  </tr>
  <tr>
    <td></td>
    <td>The Parameter image matches the Value entered above</td>
  </tr>
  <tr>
    <td></td>
    <td>The Parameter flavor matches the Value entered above</td>
  </tr>
  <tr>
    <td></td>
    <td>The Parameter key matches the Value entered above</td>
  </tr>
  <tr>
    <td></td>
    <td>The Parameter availability_zone matches the Value entered above</td>
  </tr>
  <tr>
    <td></td>
    <td>The Parameter tenancy_name matches the Value entered above</td>
  </tr>
  <tr>
    <td></td>
    <td>The Parameter email_postmaster matches the Value entered above</td>
  </tr>
  <tr>
    <td></td>
    <td>The Parameter hub_zero_version matches the Value entered above</td>
  </tr>
  <tr>
    <td></td>
    <td>The Parameter hostname matches the Value entered above</td>
  </tr>
  <tr>
    <td></td>
    <td>The Parameter nagiosserver matches the Value entered above</td>
  </tr>
  <tr>
    <td></td>
    <td>The Parameter nectar_user_id matches the Value entered above</td>
  </tr>
  <tr>
    <td></td>
    <td>The Parameter pgp_passphraze is hidden by checkmarks</td>
  </tr>
  <tr>
    <td></td>
    <td>The Parameter swift_password is hidden by checkmarks</td>
  </tr>
</table>


### Test 2: Once built, does the stack apply Parameters correctly? 

Navigate to the instances tab of the dashboard ([https://dashboard.rc.nectar.org.au/project/instances/](https://dashboard.rc.nectar.org.au/project/instances/)). There will be an instance, whose instance name starts with "<stack-name>-hubZero_instance-"

Select the instance link to see the instance information.

In this page are the following Assertions true?

<table>
  <tr>
    <td>Result</td>
    <td>Assertion</td>
  </tr>
  <tr>
    <td></td>
    <td>The Parameter availability_zone matches (or is in) the Availability Zone Value in the Info section</td>
  </tr>
  <tr>
    <td></td>
    <td>The Parameter flavor matches the Flavor Value in the Specs section</td>
  </tr>
  <tr>
    <td></td>
    <td>The Parameter key matches the Key Name Value in the Meta section</td>
  </tr>
  <tr>
    <td></td>
    <td>The Parameter image matches  the Image Name Value in the Meta section</td>
  </tr>
</table>


### Test 3: Once built, does the stack have the correct outputs?

Navigate to the stacks tab of the dashboard ([https://dashboard.rc.nectar.org.au/project/stacks/](https://dashboard.rc.nectar.org.au/project/stacks/)). Select the link with the stack name. Then select the **Overview** tab of the stack.

Are the following Assertions true?

<table>
  <tr>
    <td>Result</td>
    <td>Assertion</td>
  </tr>
  <tr>
    <td></td>
    <td>In the Outputs section of the page there is an output named instance_ssh</td>
  </tr>
  <tr>
    <td></td>
    <td>The instance_ssh Value has the Parameter key Value in it</td>
  </tr>
</table>


### Test 4: Once built, can the machine be accessed via ssh?

Open a command line terminal. Copy and paste the `instance_ssh` Value into it. If the selected key location does not match the one given in the command, edit the -i argument to match the location. Hit the enter key.

Is the following Assertion true?

<table>
  <tr>
    <td>Result</td>
    <td>Assertion</td>
  </tr>
  <tr>
    <td></td>
    <td>The HubZero instance can be accessed via ssh</td>
  </tr>
</table>


## Part 2: Validating the installation

The subsequent run by Puppet will terminate with a reboot of the machine onto which the software is being installed. 

The Puppet run can take quite a while. If you’ve left your ssh shell open on the machine you will be logged out when the reboot occurs.

You will have to ssh into the machine again, and re-verify your certificate.

Once logged in become the root user:

<table style="font-family: courier; border-style: none; background-color: #D3D3D3;">
  <tr>
    <td>$ sudo -i</td>
  </tr>
</table>


### Test 5: Does the site notify the postmaster that the install is complete?

Once the install is complete, the puppet script will send email to the address listed in the email_postmaster Parameter.

 

<table>
  <tr>
    <td>Result</td>
    <td>Assertion</td>
  </tr>
  <tr>
    <td></td>
    <td>The person in the email_postmaster Parameter received an email with the message heading "Install Progress"</td>
  </tr>
  <tr>
    <td></td>
    <td>The body of the message read “The install is complete! You can find your new hubzero site at:” followed by a url</td>
  </tr>
</table>


### Test 6: Is the site actually up?

<table>
  <tr>
    <td>Result</td>
    <td>Assertion</td>
  </tr>
  <tr>
    <td></td>
    <td>When you click on the link in the body of the email notifying that the installation was complete, received by the postmaster, you are taken to a site with an untrusted ssl certificate. 

Note: on version 1.3 of HubZero you will be taken to an unsecured  landing page which does NOT produce the certificate warning. On clicking the "Jump to your HUB" button, then you will be taken to the secured admin page which will produce the untrusted ssl certificate warning. </td>
  </tr>
</table>


### Test 7: Does mail flow to the postmaster correctly?

As root, in the ssh window, on the virtual machine, enter the command:

<table style="font-family: courier; border-style: none; background-color: #D3D3D3;">
  <tr>
    <td>$ echo "This is a test message." | mail -s "Hello from hubzero" root@localhost</td>
  </tr>
</table>


<table>
  <tr>
    <td>Result</td>
    <td>Assertion</td>
  </tr>
  <tr>
    <td></td>
    <td>Some time later, the person in the email_postmaster Parameter will receive an email with the message heading "This is a test message"</td>
  </tr>
</table>


### Test 8: Can the admin log in?

You cannot log into the site successfully unless the web browser, the database, the ldap server and the application itself have all been installed and correctly configured.

As root, in the ssh window on the virtual machine, enter the command: 

<table style="font-family: courier; border-style: none; background-color: #D3D3D3;">
  <tr>
    <td>less /etc/hubzero.secrets</td>
  </tr>
</table>


In the window brought up, make a note of the JOOMLA-ADMIN Value.

Then open your browser onto the link that was contained in the email to the postmaster notifying him of the installs completion.

On that page, select the "Login" link.

Note: for HubZero version 1.3 click on the "Jump to your HUB" button at the bottom of the page. On the admin page that then appears, select the “Login” link.

In the Resultant login page enter the username "admin" and the JOOMLA-ADMIN Value as the password.

<table>
  <tr>
    <td>Result</td>
    <td>Assertion</td>
  </tr>
  <tr>
    <td></td>
    <td>The admin login is successful. </td>
  </tr>
</table>


### Test 9: Does the machine have the correct hostname?

As root, in the ssh window on the virtual machine, enter the command:

<table style="font-family: courier; border-style: none; background-color: #D3D3D3;">
  <tr>
    <td>$ echo $(hostname)</td>
  </tr>
</table>


Is the following correct?

<table>
  <tr>
    <td>Result</td>
    <td>Assertion</td>
  </tr>
  <tr>
    <td></td>
    <td>The Result returned is the Value of the hostname Parameter. </td>
  </tr>
</table>


### Test 10: Have the Duplicity template Parameters been correctly passed through?

As root, in the ssh window on the virtual machine, enter the command:

<table style="font-family: courier; border-style: none; background-color: #D3D3D3;">
  <tr>
    <td>$ less /etc/nectar.secrets</td>
  </tr>
</table>


The Resulting file will have its variables made up as follows:

<table>
  <tr>
    <td>Result</td>
    <td>Assertion</td>
  </tr>
  <tr>
    <td></td>
    <td>The SWIFT_USERNAME variable Value is made by prepending the tenancy_name Parameter to the nectar_user_id Parameter, with a ‘:’ as the separator. </td>
  </tr>
  <tr>
    <td></td>
    <td>The SWIFT_PASSWORD variable Value is the Value of the swift_password Parameter. </td>
  </tr>
  <tr>
    <td></td>
    <td>The PASSPHRASE variable Value is the Value of the pgp_passphraze Parameter.</td>
  </tr>
</table>


### Test 11: Are the Duplicity settings secure?

As root, in the ssh window on the virtual machine, enter the commands:

<table style="font-family: courier; border-style: none; background-color: #D3D3D3;">
  <tr>
    <td>$ exit<br />
        $ less /etc/nectar.secrets</td>
  </tr>
</table>


The file should not be visible:

<table>
  <tr>
    <td>Result</td>
    <td>Assertion</td>
  </tr>
  <tr>
    <td></td>
    <td>The attempt to view the file as a non root user Resulted in the error message: "/etc/nectar.secrets: Permission denied"</td>
  </tr>
</table>


