#!/bin/bash

echo "Checking policy..."

echo ""
command='../bin/cybr conjur get-secret -i blueOrchidApplication/connectionstring'
echo ${command}
eval ${command}

echo ""
command='../bin/cybr conjur get-secret -i blueOrchidApplication/username'
echo ${command}
eval ${command}

echo ""
command='../bin/cybr conjur get-secret -i blueOrchidApplication/password'
echo ${command}
eval ${command}

echo ""
echo "Set values with e.g."
echo "conjur set-secret -i blueOrchidApplication/connectionstring -v str"
echo "conjur set-secret -i blueOrchidApplication/username -v str"
echo "conjur set-secret -i blueOrchidApplication/password -v str"
echo ""