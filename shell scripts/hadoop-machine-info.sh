#!/bin/bash

PATH=/bin:/sbin:/usr/bin:/usr/sbin

echo "****************************************"
echo "****************************************"
hostname

echo "****************************************"
echo "*** OS details"
if [ -f /etc/redhat-release ]; then
  if [ -f /etc/centos-release ]; then
    cat /etc/centos-release
  else
    cat /etc/redhat-release
  fi
elif [ -f /etc/SuSE-release ]; then
  cat /etc/SuSE-release
elif [ -f /etc/os-release ]; then
  cat /etc/os-release
fi
if [ -f /etc/lsb-release ]; then /usr/bin/lsb_release -ds; fi

echo "** cpu:"
grep ^processor /proc/cpuinfo | tail -1
grep ^"model name" /proc/cpuinfo | tail -1
echo "** memory:"
echo "memory          : $(free -g | awk '/^Mem:/{print $2}') GiB"
echo "** Disks:"
if [ "$OS" == "SUSE LINUX" ] && [ "$OSREL" == 11 ]; then
  lsblk -lo NAME,SIZE,MOUNTPOINT | awk '$1~/^NAME$/; $3~/^\//'
else
  lsblk -lo NAME,SIZE,TYPE,MOUNTPOINT | awk '$1~/^NAME$/; $3~/^disk$/'
fi
echo "** Logical Volumes:"
sudo -n pvs
echo
sudo -n vgs
echo
sudo -n lvs
echo "** Filesystems:"
df -hP -t ext2 -t ext3 -t ext4 -t xfs
echo "** Network interfaces (raw):"
ip addr

echo "****************************************"
echo "*** IPv6"
echo "** running config:"
sysctl net.ipv6.conf.all.disable_ipv6
sysctl net.ipv6.conf.default.disable_ipv6
echo "** startup config:"
grep -r net.ipv6.conf.all.disable_ipv6 /etc/sysctl.*
grep -r net.ipv6.conf.default.disable_ipv6 /etc/sysctl.*

echo "****************************************"
echo "*** SElinux"
if [ "$OS" == RedHatEnterpriseServer ] || [ "$OS" == CentOS ]; then
  echo "** running config:"
  getenforce
  echo "** startup config:"
  grep ^SELINUX= /etc/selinux/config
elif [ "$OS" == Debian ] || [ "$OS" == Ubuntu ]; then
  echo "Debian/Ubuntu = None"
elif [ "$OS" == "SUSE LINUX" ]; then
  echo "SLES = None"
fi

echo "****************************************"
echo "*** Filesystems"
echo "** noatime"
echo "** running config:"
mount | grep noatime || echo "none"
echo "** startup config:"
grep noatime /etc/fstab || echo "none"


echo "****************************************"
echo "*** Java"
echo "** installed Java(s):"
java -version

echo "****************************************"
echo "*** NSCD"
echo "** running config:"
service nscd status
echo "** startup config:"
chkconfig --list nscd

echo "****************************************"
echo "*** Date and Timezone"
timedatectl