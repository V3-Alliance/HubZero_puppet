# Upgrading from 1.2.0 through to 1.3.1

The steps I took..

The HubZero key is out of date on the 1.2.0 instance. We need to update the key.

```bash
apt-key del HUBzero Package Signing Key
wget http://packages.hubzero.org/deb/hubzero-signing-key.asc -q -O - | apt-key add -
```

Then to update to 1.2.2

```bash
apt-get install -y hubzero-cms-1.2.2
```

Before running any further scripts, I had to had to follow the instructions at 
https://help.ubuntu.com/community/MysqlPasswordReset to reset the root password to match the one in the 
hubzero secrets file.

```sql
SET PASSWORD FOR root@'localhost' = PASSWORD('password_from_secrets_file');
```

Then run
 
```bash
hzcms update
```

Then I had to update the theme (I also removed google analytics from theme)

Having done that to get to a running 1.2.2, I then

```bash
vi /etc/apt/sources.list
```

and removed the shira line and replaced with

```bash
deb http://packages.hubzero.org/deb diego-deb6 main
```

Then did an:

```bash
apt-get update
apt-get -y upgrade
apt-get install -y hubzero-cms-1.3.1
hzcms update
```