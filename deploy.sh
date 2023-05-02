#!/bin/bash

read -r -p "api_key from created_roles: " api_key
aws_account_number=$(aws sts get-caller-identity --query Account --output text)

# Check if env.json exists
if [ -f "../env.json" ]; then
    env_file="../env.json"
    conjur_account=$(jq -r '.CONJUR_ACCOUNT' "$env_file")
    conjur_appliance_url=$(jq -r '.CONJUR_APPLIANCE_URL' "$env_file")
fi

read -r -p "Conjur account [$conjur_account]: " account
# if account is not empty and is not equal to conjur_account, use account
if [ ! -z "$account" && "$account" != "$conjur_account" ]; then
    conjur_account=$account
fi

read -r -p "Conjur appliance URL [$conjur_appliance_url]: " url
# if url is not empty and is not equal to conjur_appliance_url, use url
if [ ! -z "$url" && "$url" != "$conjur_appliance_url" ]; then
    conjur_appliance_url=$url
fi

# Generate the script to set the environment variables in terraform.
envscript="env.sh"
echo "#!/bin/sh" > $envscript
echo " env.sh" >> $envscript
echo "" >> $envscript
echo "# Change the contents of this output to get the environment variables" >> $envscript
echo "# of interest. The output must be valid JSON, with strings for both" >> $envscript
echo "# keys and values." >> $envscript
echo "cat <<EOF" >> $envscript
echo "{" >> $envscript
echo "  \"LAMBDA_FUNCTION\" : \"blueOrchidApplication\"," >> $envscript
echo "  \"LAMBDA_FUNCTION_HANDLER\" : \"main\"," >> $envscript
echo "  \"CONJUR_ACCOUNT\" : \"$conjur_account\"," >> $envscript
echo "  \"CONJUR_APPLIANCE_URL\" : \"$conjur_appliance_url\"," >> $envscript
echo "  \"CONJUR_CERT_FILE\" : \"./conjur-dev.pem\"," >> $envscript
echo "  \"CONJUR_AUTHN_LOGIN\" : \"host/blueOrchidApplication/$aws_account_number/blueOrchidApplication\"," >> $envscript
echo "  \"CONJUR_AUTHN_API_KEY\" : \"$api_key\"," >> $envscript
echo "  \"CONJUR_AUTHENTICATOR\" : \"authn-iam\"," >> $envscript
echo "  \"DB_PORT\" : \"5432\"" >> $envscript
echo "}" >> $envscript
echo "EOF" >> $envscript

chmod u+x $envscript
cp $envscript config/env/env.sh
cp $envscript deploy/env.sh

# check if config/env/env.sh exists
#if [ ! -e "config/env/env.sh" ]; then
#    cp ../env.sh ./config/env/env.sh
#fi
#(cp config/env/env.sh deploy/env.sh)

(cd deploy; mkdir -p archive)
(cd deploy; cp ../bin/main ./archive)
(cd deploy; cp ../cert/conjur-dev.pem ./archive)

(cd deploy; terraform init)
(cd deploy; terraform plan)

echo ""
echo ""
echo "Run 'terraform apply' to deploy the lambda function."