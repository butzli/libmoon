#!/bin/bash
mkdir -p /mnt/huge
(mount | grep hugetlbfs) > /dev/null || mount -t hugetlbfs nodev /mnt/huge
# 2048 huge pages (4 GB) per NUMA node instead of 512: with 15 transmit and 15 receive cores, the packet buffer pools
# nearly fill 1 GB, and every receive queue of the IPsec scripts creates all inbound SAs (about 2 KB each with the
# crypto session), so that 2048 SAs would no longer fit
for i in {0..7}
do
	if [[ -e "/sys/devices/system/node/node$i" ]]
	then
		echo 2048 > /sys/devices/system/node/node$i/hugepages/hugepages-2048kB/nr_hugepages
	fi
done

