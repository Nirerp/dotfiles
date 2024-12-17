#!/bin/bash
layout=$(xkblayout-state print %s)
if [ "$layout" == "us" ]; then
    echo "ENG"
else
    echo "HE"
fi