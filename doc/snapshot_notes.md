## Snapshots

The nova backup command is not safe, unless you have synced and frozen the file system.

On debian to freeze the file system we need to install `xfs_freeze`:

```bash
apt-get install xfsprogs -y
```

To freeze it from inside an ssh shell, we need to do the following:

```bash
xfs_freeze -f / && read x; xfs_freeze -u /
```

Otherwise we will fre

To do a proper sync, we need to:

* Stop mysql: `service mysql stop`
* Sync the disk: `sync`
* Freeze the filesystem: `xfs_freeze -f /`

Once the snapshot is taken, we need to:

* Unfreeze the file system: `xfs_freeze -u /`
* Start mysql: `service mysql start`

As we are working with the root file system we run the risk of having the system lock up permanently :(

So - a freeze script would be:

```bash
#!/bin/bash -e
service mysql stop
sync
xfs_freeze -f /
```

And a 