#!/bin/bash
df -h | grep 'sddisk' | awk '{print $5}'
