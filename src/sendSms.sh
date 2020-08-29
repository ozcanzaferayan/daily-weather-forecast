BASE_URL='https://api.twilio.com'
echo "::set-env name=SMS_TEXT::$(echo 'zaferayan')"
curl -X POST ${BASE_URL}/2010-04-01/Accounts/$(echo process.env.TWILIO_ACCOUNT_SID)/Messages.json \
    --data-urlencode "Body=$(cat sms.txt)" \
    --data-urlencode "From=$(echo process.env.MSISDN_SENDER)" \
    --data-urlencode "To=$(echo process.env.MSISDN_RECEIVER)" \
    -u $(echo process.envets.TWILIO_ACCOUNT_SID):$(echo process.env.TWILIO_AUTH_TOKEN)