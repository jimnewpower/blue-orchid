#!/bin/bash

# Read values from file
while read -r line; do
  case $line in
    account:*)
      account=$(echo "$line" | cut -d':' -f2 | tr -d '[:space:]')
      ;;
    appliance_url:*)
      appliance_url=$(echo "$line" | cut -d':' -f2- | tr -d '[:space:]')
      ;;
    cert_file:*)
      cert_file=$(echo "$line" | cut -d':' -f2- | tr -d '[:space:]')
      ;;
    plugins:*)
      plugins=$(echo "$line" | cut -d':' -f2- | tr -d '[:space:]')
      ;;
    *)
      ;;
  esac
done < "$HOME/.conjurrc"

# Print values
echo "Account: $account"
echo "Appliance URL: $appliance_url"
echo "Cert File: $cert_file"
echo "Plugins: $plugins"
