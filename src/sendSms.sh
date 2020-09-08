BASE_URL='https://api.twilio.com'
echo $MSISDN_RECEIVERS_DELIMITED_WITH_SEMICOLON | tr \; \\n | while read receiver;
do
    curl -X POST ${BASE_URL}/2010-04-01/Accounts/$TWILIO_ACCOUNT_SID/Messages.json \
    --data-urlencode "Body=$(cat sms.txt)" \
    --data-urlencode "From=$MSISDN_SENDER" \
    --data-urlencode "To=$receiver" \
    -u $TWILIO_ACCOUNT_SID:$TWILIO_AUTH_TOKEN
done
