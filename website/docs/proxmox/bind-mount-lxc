---
title: "Bind Mount Unprivileged LXC"
tags:
    - lxc
    - proxmox
    - tutorial
---
## LXC (_as root_)
1. Create a group, _lxc_shares_, with `GID=10000` in the LXC, which will match `GID-11000` on the PVE host.

```shell
groupadd -g 10000 lxc_shares
```

2. Add the user(s) that need access to the CIFS share to the group _lxc_shares_ (e.g. Jellyfin, Plex).

```shell
usermod -aG lxc_shares {USERNAME}
```
3. Shut down the LXC.

## Proxmox Host (_as root_)
1. Create the mount point on the PVE host.
```shell
mkdir -p /mnt/nas-share
```

2. Add NAS CIFS share to `/etc/fstab`.
```shell
//{NFS_SHARE} /mnt/nas-share cifs _netdev,x-systemd.automount,noatime,uid=10000,gid=110000,dir_mode=0770,file_mode=0770,credentials=/root/.smb-credentials 0 0
```

3. Mount the new share on the PVE host.
```shell
mount /mnt/nas-share
```

4. Add a bind mount to the LXC configuration.
```shell
pct set {LXC_ID} -mp0 /mnt/nas-share,mp={LXC_PATH}
```