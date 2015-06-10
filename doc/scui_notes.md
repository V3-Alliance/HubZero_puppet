# First upgrade

## seo not working

Reading through: http://forum.joomla.org/viewtopic.php?t=671239 it would seem that it should work, but that another 
module is interfering with it somehow.... BTW, the fix suggested doesn't work for us...

However, in digging into the var/www/sciu/includes/application.php getTemplate method, it would seem 
that JRequest::getInt('Itemid') fails if the SEO is turned on.

## hidden menu items not working for themes.

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

## put in hook for different theme for front page:

Change the getTemplate method in
/var/www/sciu/includes/application.php
to have the hack below added:

$id = 0;
if (is_object($item)) { // valid item retrieved
$id = $item->template_style_id;
}
// ---- START HACK FOR SCIU ----
// This hack makes only the home page not use the default fial template but the sciu one instead
else if (!JRequest::getInt('catid')) {
$id = 13; // ID of the sciu template shown in the template listing page
}
// ---- END HACK FOR SCIU ----

## users have different database id's to system id's

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

## not all users have accepted the usage agreement.

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

# Second upgrade

Having done the first upgrade, we need to perform another that enables logins and the SEO links (as it would appear
that some of HubZero's javascript makes the assumption the site is being run with SEO links. In preparing for this
we found some more issues that needed fixing.

# some empty directories remain

The upgrade from 1.2 -> 1.3.1 left empty directories that are being scanned when installing extensions: and the
extension manager thoughtfully displays an error message as the directories are empty. The fix is to remove them.

The following need to be removed:

```bash
rm -r /var/www/sciu/modules/mod_banners
rm -r /var/www/sciu/modules/mod_finder
rm -r /var/www/sciu/modules/mod_myfavorites
rm -r /var/www/sciu/modules/mod_weblinks
rm -r /var/www/sciu/modules/mod_wrapper
rm -r /var/www/sciu/modules/mod_xwhosonline
rm -r /var/www/sciu/administrator/modules/mod_logged
rm -r /var/www/sciu/administrator/modules/mod_status
rm -r /var/www/sciu/templates/atomic/
rm -r /var/www/sciu/administrator/templates/bluestork/
rm -r /var/www/sciu/administrator/templates/hathor/
```

## fix the themes:

We raised HubZero ticket [8092](https://hubzero.org/support/ticket/8092) as we discovered why SEO wasn't working.

First off, as administrator on the site make sure that neither the FIAL or the SCIU themes are selected as a default
theme (select hub1013 as the default).

Then using the extension manager to delete the existing themes. 

Have done that ssh into the site and remove all trace of the old copy of the themes.

```bash
sudo -i

rm -r /var/www/sciu/tmp/fial/
rm -r /var/www/sciu/tmp/sciu
rm -r /var/www/sciu/templates/fial/
rm -r /var/www/sciu/templates/sciu
```

From the root home directory upgrade the copy of the themes to the latest version:

```bash
cd HubZero_SCIU_themes/
git pull
```

Then copy them into a location that extension manager can use to install them:

```bash
cp -vr fial/ /var/www/sciu/tmp
cp -vr sciu/ /var/www/sciu/tmp
```

Then install them using the extension manager.

In the theme manager set the SCIU theme to be the default theme.
Click on the FIAL theme, and in the resultant dialog select the FIAL menu items that are to be displayed as FIAL themed
items.

Finally, apply our bug fix via the command line:

``` bash
vim /var/www/sciu/includes/application.php
```

Delete the old lines in the `getTemplate` method that read:

```php
// ---- START HACK FOR SCIU ----
// This hack makes only the home page not use the default fial template but the sciu one instead
else if (!JRequest::getInt('catid')) {
$id = 13; // ID of the sciu template shown in the template listing page
}
// ---- END HACK FOR SCIU ----
```

Then find the last few lines of the method that read:

```php
       // Cache the result
       $this->template = $template;
```

to be:

```php
// Cache the result
if ($item) {
$this->template = $template;
}
```

## restore fancybox on profile page

We raised HubZero ticket [8060](https://hubzero.org/support/ticket/8060) as we discovered why the fancybox wasn't 
working.

Apply our bug fix via the command line:

``` bash
vim /var/www/sciu/plugins/members/profile/views/index/tmpl/default.php
```

and change:

```php
$this->css()
->js()
->js('jquery.fileuploader.js', 'system');
```

to:

```php
$this->css()
->css('jquery.fancybox.css', 'system')
->js()
->js('jquery.fileuploader.js', 'system');
```

## change the site over to seo

And all being well, the site should now work properly

# Usefull PHP code

[print-r](http://php.net/manual/en/function.print-r.php)

```php
$e = new Exception;
var_dump($e->getTraceAsString());

echo '$i=' . $i; 

JFactory::getApplication()->enqueueMessage('Some debug string(s)');
```
