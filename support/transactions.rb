require 'rubygems'
require 'rest_client'

url = 'https://prod-api.level-labs.com/api/v2/core/get-all-transactions'
# @payload = {:'args'=> {
#                     :'uid'=>'1110590645',
#                     :'password'=>'25782A6311D94286F440F583A2F57F3E',
#                     :'api-token' => 'AppTokenForInterview',
#                     :'json-strict-mode' => false,
#                     :'json-verbose-response' => false
#                     }
#           }

@payload = '{"args":{
                    "uid":1110590645,
                    "password":"25782A6311D94286F440F583A2F57F3E",
                    "api-token": "AppTokenForInterview",
                    "json-strict-mode":false,
                    "json-verbose-response": false
                    }
          }'
# @headers = {
#             :'accept' => 'application/json',
#             :'content-type' => 'application/json'
#           }
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
puts response.body
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











