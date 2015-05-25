# seo not working

Reading through: http://forum.joomla.org/viewtopic.php?t=671239 it would seem that it should work, but that another 
module is interfering with it somehow.... BTW, the fix suggested doesn't work for us...

However, in digging into the var/www/sciu/includes/application.php getTemplate method, it would seem 
that JRequest::getInt('Itemid') fails if the SEO is turned on.

# hidden menu items not working for themes.

To give pages that don't have menu items a different theme the following is suggested:

*'The problem with creating the menu-item and keeping it unpublished is that any menu parameters which are set, do 
not take effect if the menu-item is unpublished. You can link to the component and the content-item just fine this 
way, but you can NOT effectively assign any menu-specific details like template or modules if the menu-item is 
unpublished. You can specify the assignments, but they won't take effect.*
 
*So, what I and others I know do, is, create a new, separate menu in the menu manager, call it "Hidden Menu" or 
"Special Views" or something, and add all the menu-items we want to that menu, and publish all the menu-items, and 
then... the magic is... just don't create a module for displaying the menu! 
That's how the items all remain both hidden but also effective. 
Then you can just take those menu-item URLs and paste/enter them elsewhere.'*

However, this doesn't work on a standard HubZero 3.1 install.

# put in hook for different theme for front page:

Change the getTemplate method in
/var/www/sciu/includes/application.php
to have the hack below added:

$id = 0;
if (is_object($item)) { // valid item retrieved
$id = $item->template_style_id;
}
// ---- START HACK FOR SCIU ----
// This hack makes only the home page not use the default fial template but the sciu one i:q
nstead
else if (!JRequest::getInt('catid')) {
$id = 13; // ID of the sciu template
}
// ---- END HACK FOR SCIU ----

# users have different database id's to system id's

HubZero now checks to see if the users system id and the database user id are the same or not. If they
are different, it issues a warning: 

> There seems to be the following issue(s) with your user account:
> Username mismatch error, please contact system administrator to fix your account.

To fix it I made a note of the user id shown in the Users -> Members manager, then at the command line on the system 
confirmed that they were different:

```bash
$ id -u bob
501
```

Having done that I updated the users system id to match that in the database:

```bash
$ usermod -u 1001 bob
```

And the problem was solved.

We would have to do this for all users... 

# not all users have accepted the usage agreement.

The usageAgreement column is not '1' for all users in the `jos_xprofiles` table. To fix this, run the following for
each user affected:

```sql
UPDATE jos_xprofiles SET usageAgreement = 1 where uidNumber = 1001;
```

This shows the people who have not accepted the usage agreement:

```sql
SELECT uidNumber, name, username, usageAgreement FROM jos_xprofiles;
```

The real problem is caused by our theme hiding the terms and condition dialogue when the user logs in. The better fix
is to actually sort this out.


