#!/usr/bin/python
"""NRPE check for available (free + buffers + cache) memory.

Generates a warning state if the available physical memory is less than  -w
(default 512MB), and a critical state if the physical memory exceeds -c
(default 256MB).
"""

import psutil

import argparse
import sys

MB = 1024 ** 2  # bytes in a Megabyte

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument(
    "-w",
    type=int,
    default=512,
    help='warning level',
    )
parser.add_argument(
    "-c",
    type=int,
    default=256,
    help='critical level',
    )
args = parser.parse_args()

#have to use avail_phymem to support psutils v 0.5 in debian wheezy.
try:
    physmem = psutil.virtual_memory().available / MB  #psutils >= 0.6
except AttributeError:  # have to use old api
    physmem = (( psutil.avail_phymem() + 
                 psutil.phymem_buffers() +
                 psutil.cached_phymem() 
                ) / MB   
              )

if args.c >= args.w:
    print ('UNKNOWN: critical level must be less than warning level')
    sys.exit(3)
if physmem > args.w:
    print ("OK - %#s megabytes of physical memory available." % physmem)
    sys.exit(0)
elif physmem > args.c:
    print ("WARNING - %#s megabytes of physical memory available." %
            physmem)
    sys.exit(1)
elif physmem <= args.c:
    print ("CRITICAL - %#s megabytes of physical memory available." %
            physmem)
    sys.exit(2)
else:
    print ("UNKNOWN - %#s megabytes of physical memory used. " % physmem +
           "Something is awry.")
    sys.exit(3)
