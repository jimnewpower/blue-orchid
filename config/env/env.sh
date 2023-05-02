#!/bin/sh
 env.sh

# Change the contents of this output to get the environment variables
# of interest. The output must be valid JSON, with strings for both
# keys and values.
cat <<EOF
{
  "LAMBDA_FUNCTION" : "blueOrchidApplication",
  "LAMBDA_FUNCTION_HANDLER" : "main",
  "CONJUR_ACCOUNT" : "prima",
  "CONJUR_APPLIANCE_URL" : "https://ec2-34-204-42-151.compute-1.amazonaws.com",
  "CONJUR_CERT_FILE" : "./conjur-dev.pem",
  "CONJUR_AUTHN_LOGIN" : "admin",
  "CONJUR_AUTHN_API_KEY" : "18wv7sck9a66015fzsv3252qfvp23anzs81qkn4f916fbs3t228p4nb",
  "CONJUR_AUTHENTICATOR" : "authn-iam",
  "DB_PORT" : "5432"
}
EOF
