BASE_URL='https://api.twilio.com'
echo "::set-env name=SMS_TEXT::$(echo 'zaferayan')"
curl -X POST ${BASE_URL}/2010-04-01/Accounts/${{ secrets.TWILIO_ACCOUNT_SID }}/Messages.json \
    --data-urlencode "Body=$(cat sms.txt)" \
    --data-urlencode "From=${{ secrets.MSISDN_SENDER }}" \
    --data-urlencode "To=${{ secrets.MSISDN_RECEIVER }}" \
    -u ${{ secrets.TWILIO_ACCOUNT_SID }}:${{ secrets.TWILIO_AUTH_TOKEN }}