#!/bin/bash

if [ -e "/srv/data/papyri.info/sosol/editor/editor.war" ]; then
  exit 0
else
  exit 1
fi
