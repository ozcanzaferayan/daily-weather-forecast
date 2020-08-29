BASE_URL='https://api.twilio.com'
echo "::set-env name=SMS_TEXT::$(echo 'zaferayan')"
curl -X POST ${BASE_URL}/2010-04-01/Accounts/${process.env.TWILIO_ACCOUNT_SID}/Messages.json \
    --data-urlencode "Body=$(cat sms.txt)" \
    --data-urlencode "From=${process.env.MSISDN_SENDER}" \
    --data-urlencode "To=${process.env.MSISDN_RECEIVER}" \
    -u ${process.envets.TWILIO_ACCOUNT_SID}:${process.env.TWILIO_AUTH_TOKEN}