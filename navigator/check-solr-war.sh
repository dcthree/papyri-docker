#!/bin/bash

if [ -e "/srv/data/papyri.info/git/navigator/pn-dispatcher/target/dispatch.war" ]; then
  exit 0
else
  exit 1
fi
