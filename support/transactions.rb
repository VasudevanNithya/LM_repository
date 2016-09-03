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

# def calculate_aggregate(amount)
#   transaction_amount = amount.to_i
#   if (transaction_amount)>=0
#     credits = credits + transaction_amount
#   elsif (transaction_amount)<0
#     debits = debits + transaction_amount.abs
#   else
#     raise "Unknown amount"
#   end
#   aggregate_amount = credits - debits
#   return aggregate_amount
# end

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

    reference_date = Time.parse(transaction_data['transactions'][0]['transaction-time']).strftime('%Y%m')

    @aggregate = 0
    @debits = 0
    @credits = 0


    transaction_data['transactions'].each do |t|

        transaction_time = Time.parse(t['transaction-time']).strftime("%Y%m")
        transaction_month = Time.parse(t['transaction-time']).strftime("%m")
        transaction_year = Time.parse(t['transaction-time']).strftime("%Y")
        number_of_days = Date.civil(transaction_year.to_i, transaction_month.to_i,-1).day

#        Assuming transaction date is sorted in ascending order in response
      if transaction_time == reference_date
        # @aggregate = @aggregate+calculate_aggregate(transaction_time['amount'],@credits,@debits)
        transaction_value = t['amount']
        if transaction_value>=0
          @credits = @credits+transaction_value
        else
          @debits = @debits+transaction_value.abs
        end

      else
        puts "aggregate for #{reference_date} is #{@credits-@debits}"
        puts "credits = #{@credits}"
        puts "debits = #{@debits}"
        reference_date = (Date.parse(t['transaction-time'])).strftime('%Y%m')
        @aggregate = 0
        @debits = 0
        @credits = 0
        transaction_value = t['amount']
        if transaction_value>=0
          @credits = @credits+transaction_value
        else
          @debits = @debits+transaction_value.abs
        end
        # @aggregate = t['amount']

      end


    end


#       Calculate average transaction amount for each month





rescue RestClient::ExceptionWithResponse => err
    puts err
end

# begin
# response = RestClient::Request.execute(
#                                   method: :post,
#                                   url: 'https://prod-api.level-labs.com/api/v2/core/get-all-transactions',
#                                   payload: {source: @payload},
#                                   headers: {source: @headers}
# )
# puts response.body
# rescue RestClient::ExceptionWithResponse => err
#   puts err
# end

# response = RestClient.post(url,
#                             @payload,
#                             @headers)



# $rest_api = RestApi.new()
# @getTransactoinheaders = $rest_api.get_headers 'GetAllTransactions','headers'
# p @getTransactoinheaders
#
#
# @resp = $rest_api.rest_post @getTransactoinheaders











