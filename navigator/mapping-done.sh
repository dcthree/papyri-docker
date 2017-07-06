#!/bin/bash

if [ -e "/root/mapping_done" ]; then
  exit 0
else
  exit 1
fi
