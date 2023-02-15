#!/bin/bash
# Change tempdir for Android devices - use /data/local/tmp instead
sed -i '4153 s/tempdir/\"\/data\/local\/tmp\"/g' /tmp/iperf-3.11/src/iperf_api.c 
sed -i '4142,4152d' /tmp/iperf-3.11/src/tmp_iperf_api.c 
sed -i '415 s/\ 86400/\ 864000/g'   /tmp/iperf-3.11/src/iperf.h 
