#!/bin/bash

if [ -e "/srv/data/papyri.info/mapping_done" ]; then
  exit 0
else
  exit 1
fi
