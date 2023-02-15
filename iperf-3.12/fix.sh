#!/bin/bash
# Change tempdir for Android devices - use /data/local/tmp instead
sed -i '4201 s/tempdir/\"\/data\/local\/tmp\"/g' /tmp/iperf-3.12/src/iperf_api.c 
sed -i '4190,4200d' /tmp/iperf-3.12/src/tmp_iperf_api.c 
sed -i '423 s/\ 86400/\ 864000/g' /tmp/iperf-3.12/src/iperf.h 
