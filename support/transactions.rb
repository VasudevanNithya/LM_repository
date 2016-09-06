require 'rest_client'
require 'date'
require 'time'
require 'json'
require 'optparse'

options = {}
OptionParser.new do |opts|

  opts.on("--ignoredonuts", "Ignore donuts") do |i|
    options[:ignoredonuts] = i
  end
end.parse!

url = 'https://prod-api.level-labs.com/api/v2/core/get-all-transactions'

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
rescue
  raise 'Error executing POST request'
end

begin
    reference_date = Time.parse(transaction_data['transactions'][0]['transaction-time']).strftime('%Y-%m')

    @aggregate = 0
    @debits = 0
    @credits = 0
    @donut_debit =0
    elements = transaction_data['transactions'].length
    count = 0
    number_of_credits = 0
    number_of_debits = 0
    end_of_month = false

    puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"," "

    transaction_data['transactions'].each do |t|
        transaction_time = Time.parse(t['transaction-time']).strftime("%Y-%m")
        transaction_month = Time.parse(t['transaction-time']).strftime("%m")
        transaction_year = Time.parse(t['transaction-time']).strftime("%Y")

        begin
        next_transaction_time = Time.parse(transaction_data['transactions'][count+1]['transaction-time']).strftime('%Y-%m')
        rescue
          next_transaction_time=transaction_time
        end

        begin
        if (next_transaction_time == transaction_time) && (count < elements-1)
          @number_of_days = Date.civil(transaction_year.to_i, transaction_month.to_i,-1).day
          end_of_month = false
        else (next_transaction_time > transaction_time) || (count == elements-1)
          end_of_month = true
        end
        rescue RestClient::ExceptionWithResponse => err
          puts err
        end

#        Assuming transaction date is sorted in ascending order in response
        if transaction_time == reference_date
            transaction_amount = (t['amount'].to_i)
            if transaction_amount>=0
              @credits = @credits + transaction_amount
              number_of_credits = number_of_credits+1
            else
              @debits = @debits + transaction_amount.abs
              number_of_debits = number_of_debits+1
            end

            if (options[:ignoredonuts] == true)
              if (t['merchant'] == 'Krispy Kreme Donuts') || (t['merchant'] == 'Dunkin #336784')
                @donut_debit = @donut_debit + transaction_amount.abs
                number_of_donutdebits = number_of_debits-1
              end
            end

            if end_of_month == true
              puts "Averages for month #{transaction_time} by number of credits/debits"
              average_credits_bynumber = '%.2f' % ((@credits/number_of_credits).to_i/10000)
              average_debits_bynumber = '%.2f' % ((@debits/number_of_debits).to_f/10000)
              puts "Income from #{number_of_credits} transactions = $#{average_credits_bynumber} (/credit transaction)"
              puts "Expenditure from #{number_of_debits} transactions = $#{average_debits_bynumber} (/debit transaction)"," "

              puts "Averages for month #{transaction_time} over #{@number_of_days} days"
              average_credits = '%.2f' % ((@credits/@number_of_days).to_i/10000)
              average_debits = '%.2f' % ((@debits/@number_of_days).to_f/10000)
              puts "Income = $#{average_credits} (/day)"
              puts "Expenditure = $#{average_debits} (/day)"," "

              if options[:ignoredonuts] == true
              donut_debit_amount = '%.2f' % (((@debits-@donut_debit)/@number_of_days).to_f/10000)
              puts "Average expenditure for #{transaction_time} over #{@number_of_days} days without donut expense = $#{donut_debit_amount} (/day)",""
              end

              puts "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"," "
              end_of_month = false
            end
        else
          #Reset values at beginning of new month
          reference_date = (Date.parse(t['transaction-time'])).strftime('%Y-%m')
          @aggregate = 0
          @debits = 0
          @credits = 0
          number_of_credits =0
          number_of_debits=0
          @donut_debit = 0
          average_credits_bynumber = 0
          average_debits_bynumber = 0
          donut_debit_amount = 0
          average_credits = 0
          average_debits = 0
          #Redo iteration to calculate totals for first transaction of new month
          redo
        end

    count = count+1
    end
rescue
  raise 'Error iterating through transaction data'
end
