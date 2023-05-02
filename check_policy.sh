#!/bin/bash

echo "Checking policy..."

echo ""
command='./cybr conjur get-secret -i blueOrchidApplication/dbUrl'
echo ${command}
eval ${command}

echo ""
command='./cybr conjur get-secret -i blueOrchidApplication/dbUsername'
echo ${command}
eval ${command}

echo ""
command='./cybr conjur get-secret -i blueOrchidApplication/dbPassword'
echo ${command}
eval ${command}

echo ""
command='./cybr conjur get-secret -i blueOrchidApplication/githubUsername'
echo ${command}
eval ${command}

echo ""
command='./cybr conjur get-secret -i blueOrchidApplication/githubPassword'
echo ${command}
eval ${command}

echo ""
echo "Set values with e.g."
echo "conjur set-secret -i blueOrchidApplication/githubUsername -v str"
echo "conjur set-secret -i blueOrchidApplication/githubPassword -v str"
echo "conjur set-secret -i blueOrchidApplication/dbUrl -v str"
echo "conjur set-secret -i blueOrchidApplication/dbUsername -v str"
echo "conjur set-secret -i blueOrchidApplication/dbPassword -v str"
echo ""