require 'rubygems'
require 'rest_client'
require 'date'
require 'time'
require 'json'

url = 'https://prod-api.level-labs.com/api/v2/core/get-all-transactions'

@payload = '{"args":{
                    "uid":1110590645,
                    "password":"25782A6311D94286F440F583A2F57F3E",
                    "api-token": "AppTokenForInterview",
                    "json-strict-mode":false,
                    "json-verbose-response": false
                    }
          }'

@headers = '{
            "accept": "application/json",
            "content-type": "application/json"
          }'

begin
    response = RestClient.post(url,
                               {'args'=>{'uid'=>1110590645,
                               'token'=>'25782A6311D94286F440F583A2F57F3E',
                                'api-token' => 'AppTokenForInterview',
                                'json-strict-mode' => false,
                                'json-verbose-response' => false
                               }}.to_json,
                               'accept' => 'application/json',
                               'content-type'=>'application/json')
    transaction_data = JSON.parse(response.body)

    reference_date = Time.parse(transaction_data['transactions'][0]['transaction-time']).strftime('%Y-%m')

    @aggregate = 0
    @debits = 0
    @credits = 0

    elements = transaction_data['transactions'].length
    puts elements

    count = 0
    end_of_month = false

    transaction_data['transactions'].each do |t|
        transaction_time = Time.parse(t['transaction-time']).strftime("%Y-%m")
        transaction_month = Time.parse(t['transaction-time']).strftime("%m")
        transaction_year = Time.parse(t['transaction-time']).strftime("%Y")

        begin
        next_transaction_time = Time.parse(transaction_data['transactions'][count+1]['transaction-time']).strftime('%Y-%m')
        rescue
          next_transaction_time=transaction_time
        end

        if (next_transaction_time) == transaction_time && (count < elements-1)
          @number_of_days = Date.civil(transaction_year.to_i, transaction_month.to_i,-1).day
          end_of_month = false
        elsif count == elements-1
          end_of_month = true
        else
          end_of_month = true
        end

#        Assuming transaction date is sorted in ascending order in response
        if transaction_time == reference_date
            transaction_amount = (t['amount'].to_i)
            if transaction_amount>=0
              @credits = @credits + transaction_amount
            else
              @debits = @debits + transaction_amount.abs
            end
            @aggregate = @credits - @debits

            if end_of_month == true
              average_credits = '%.2f' % ((@credits/@number_of_days).to_i/10000)
              puts "average income for month #{transaction_time} = $#{average_credits}"
              average_debits = '%.2f' % ((@debits/@number_of_days).to_f/10000)
              puts "average expenditure for month #{transaction_time} = $#{average_debits}"," "
              end_of_month = false
            end
        else

          reference_date = (Date.parse(t['transaction-time'])).strftime('%Y-%m')
          @aggregate = 0
          @debits = 0
          @credits = 0

        end

    count = count+1
    end


rescue RestClient::ExceptionWithResponse => err
    puts err
end