#!/bin/bash

echo "Running whoami:"
./cybr conjur whoami
echo ""

while true; do
    read -p "Are you currently logged in as admin? (yes/no) " yn
    case $yn in
        [Yy]* ) 
            echo "User selected Yes"
            # Add your code for "Yes" case here
            break
            ;;
        [Nn]* ) 
            echo "Exiting. Please logon as admin and run again."
            echo "e.g. conjur logon --self-signed -a prima -p <password> -b https://ec2-34-204-42-151.compute-1.amazonaws.com -l admin"
            # Add your code for "No" case here
            exit
            ;;
        * ) 
            echo "Please answer yes or no.";;
    esac
done

aws_account_number=$(aws sts get-caller-identity --query Account --output text)


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
echo ""
echo "Account: $account"
echo "Appliance URL: $appliance_url"
echo "Cert File: $cert_file"
echo ""

append_root='./cybr conjur append-policy -b root -f ./config/policy/root-policy.yml'
echo ""
echo ${append_root}
eval ${append_root}
echo ""

#append_secrets='./cybr conjur append-policy -b conjur/authn-iam/dev -f ./config/policy/secrets.yml'
#echo ${append_secrets}
#eval ${append_secrets}

append_application='./cybr conjur append-policy -b blueOrchidApplication -f ./config/policy/application.yml'
echo ""
echo ${append_application}
eval ${append_application}
echo ""

aws_account_number=$(aws sts get-caller-identity --query Account --output text)
host="host/blueOrchidApplication/$aws_account_number/blueOrchidApplication"

echo ""
echo "!!!!!!!!!!!!!!!!!!!!!!!"
echo "Copy the api_key above."
echo "!!!!!!!!!!!!!!!!!!!!!!!"
echo "2. Logon to Conjur as host/blueOrchidApplication/$aws_account_number/blueOrchidApplication"
echo "3. Set secret values in Conjur: connectionstring, username, password"
echo ""
echo "e.g. conjur set-secret -i blueOrchidApplication/connectionstring -v connectionstring"
echo ""

echo ""
echo "Logging into Conjur. Accept the certificate, and replace the rc files."
echo "conjur logon --self-signed -a $account -b $appliance_url -l $host"
echo ""

./cybr conjur logon --self-signed -a $account -b $appliance_url -l $host
# Accept certificate, replace rc files. Then, copy the cert to the cert directory.

echo ""
echo "cp ~/conjur-prima.pem ./cert/conjur-dev.pem"
cp ~/conjur-prima.pem ./cert/conjur-dev.pem
echo ""

echo ""
echo "Next: set secret values in Conjur: connectionstring, username, password"
echo ""
echo "e.g. conjur set-secret -i blueOrchidApplication/connectionstring -v connectionstring"
echo ""
