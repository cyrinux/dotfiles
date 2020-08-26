#!/bin/bash

# vim: softtabstop=4 shiftwidth=4 expandtab 

# Copyright (c) 2015-2019 Jari Turkia (jatu@hqcodeshop.fi)

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# See: https://blog.hqcodeshop.fi/archives/273-GNU-Parted-Solving-the-dreaded-The-resulting-partition-is-not-properly-aligned-for-best-performance.html
# for further details about using this script.

# Version history:
# 0.3   22th Nov 2019   Bugfix suggested by Nikolay
# 0.2   10th Jan 2019   Changes suggested by Patrick
# 0.1   7th Nov 2015    Initial version of parted_mkpart_calc.sh



#
# Helper:
# List suitable block devices
#
function create_suggestions {
    local SUGGESTED_DEVICES_ARR

    SUGGESTED_DEVICES_ARR=( /dev/{s,xv}d[a-z] )
    SUGGESTED_DEVICES=
    for dev in "${SUGGESTED_DEVICES_ARR[@]}"; do
        if [ ! -b $dev ]; then
            continue
        fi
        SUGGESTED_DEVICES="${SUGGESTED_DEVICES} ${dev##*/}"
    done
}

#
# Calculate the preferred sector alignment
# when a optimal_io_size is known
#
function io_size_calc {
    local  __resultvar=$1
    local dev alignment_offset start_sector optimal_io_size

    dev=$2
    optimal_io_size=$3

    # alignment_offset: how many bytes the beginning of the device is offset
    #                   from the disk's natural alignment [bytes]
    alignment_offset=$(cat /sys/block/$dev/alignment_offset)

    # Convert bytes into sectors (blocks)
    start_sector=$(( ($optimal_io_size + $alignment_offset)/$physical_block_size ))

    eval $__resultvar="'$start_sector'"
}


#
# Begin script
#

# Check command-line arguments
if [ $# -eq 0 ]; then
    # Need a block-device to work with
    create_suggestions
    echo Need block device to work with!
    echo Suggestions: ${SUGGESTED_DEVICES}

    exit 1
else
    if [ ! -b "/dev/$1" ]; then
        create_suggestions
        echo Invalid block device $1!
        echo Suggestions: ${SUGGESTED_DEVICES}

        exit 1
    fi
fi

BLOCK_DEVICE=$1
CURRENT_USER_ID=$(id -u $USER)
shift

align_to_sector=

# Do the calc
# optimal_io_size: Storage devices may report an optimal I/O size, which is
#                   the device's preferred unit for sustained I/O [bytes]
optimal_io_size=$(cat /sys/block/$BLOCK_DEVICE/queue/optimal_io_size)
stat=$?
# physical_block_size: This is the smallest unit a physical storage device
#                       can write atomically [bytes]
physical_block_size=$(cat /sys/block/$BLOCK_DEVICE/queue/physical_block_size)
stat+=$?
if [ "$stat" != "00" ]; then
    echo Internal error: Failed to extract block device information!
    exit 1
fi

if [ $optimal_io_size -le 0 ]; then
    echo Using default 1 MiB alignment in calc
    optimal_io_size=1048576
else
    echo Using detected optimal_io_size alignment of $optimal_io_size bytes in calc
fi
io_size_calc align_to_sector $BLOCK_DEVICE $optimal_io_size

if [ -z "$align_to_sector" ]; then
    echo Internal error: Failed to calculate sector alignment for device /dev/$BLOCK_DEVICE
    exit 1
fi

# Go query parted:
# Extract the free space information from the device
free_space_info=$(parted --script /dev/$BLOCK_DEVICE unit s print free)
stat=$?
if [ $stat -gt 0 ]; then
    echo Failed to run parted. Exit code: $stat
    exit $stat
fi

partition_table_type=
free_space_start=
free_space_end=
free_space_amount=
last_partition=0
while read -r line; do
    if [[ $line =~ ^Partition\ Table:\ (.+) ]]; then
        partition_table_type="${BASH_REMATCH[1]}"
        continue
    fi
    if [[ $line =~ ^([0-9]+)s\ +([0-9]+)s\ +([0-9]+).+Free\ Space ]]; then
        free_space_start="${BASH_REMATCH[1]}"
        free_space_end="${BASH_REMATCH[2]}"
        free_space_amount="${BASH_REMATCH[3]}"
        continue
    fi
    if [[ $line =~ ^([0-9]+)\ +([0-9]+)s ]]; then
        last_partition="${BASH_REMATCH[1]}"
    fi
done <<< "$free_space_info"

if [ -z "$free_space_start" ] || [ -z "$free_space_end" ]; then
    echo Failed to parse parted output!
    exit 1
fi

# Final:
# Do the aligned calc
last_partition=$(( $last_partition+1 ))
if [ $free_space_amount -lt $align_to_sector ]; then
    echo Error: cannot continue. There is no free space on the device /dev/$BLOCK_DEVICE!
    echo Minimum free amount is $align_to_sector sectors, but only $free_space_amount sectors are available.
    exit 1
fi

echo "Calculated alignment for /dev/$BLOCK_DEVICE ($partition_table_type) is: ${align_to_sector}s"
# Note: Bash eval arithmetic is integer only. Doing division and multiply wouldn't make much
#       difference with float arithmetic. Here successfully calculates optimal alignment.
aligned_start_sector=$(( (($free_space_start / $align_to_sector) + 1) * $align_to_sector ))
aligned_end_sector=$(( ($free_space_end)/$align_to_sector*$align_to_sector-1 ))

# Output
mkpart=mkpart
case $partition_table_type in
    msdos)
        if [ -z "$1" ]; then
            mkpart+=" [primary/extended/logical]"
        else
            mkpart+=" $1"
            shift
        fi
        ;;
    gpt)
        if [ -z "$1" ]; then
            mkpart+=" [name]"
        else
            mkpart+=" $1"
            shift
        fi
        ;;
esac
if [ -z "$1" ]; then
    mkpart+=" [type]"
else
    mkpart+=" $1"
    shift
fi
mkpart+=" ${aligned_start_sector}s ${aligned_end_sector}s"

echo
if [ $CURRENT_USER_ID == 0 ]; then
    echo Create partition with:
else
    echo If you would be root, you could create partition with:
fi
echo "# parted /dev/$BLOCK_DEVICE $mkpart" 
echo "Verify partition alignment with:"
echo "# parted /dev/$BLOCK_DEVICE align-check optimal $last_partition"
echo "Should return: $last_partition aligned"

