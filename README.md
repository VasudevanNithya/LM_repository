------------------------------------
File content
------------------------------------
headers.yml                 Headers and payload details
transaction_steps           Common functions
env.rb                      Declare environmental variables and depencies that needs to be loaded
transactions.rb             Program code
.gitignore                  List files that are not required to be uploaded to Git
Gemfile.rb                  List of gem dependencies
Results folder              Sample result screen shot

------------------------------------
Program logic
------------------------------------
Execute POST request
Capture POST response
Iterate through transactions to identify transaction type - credit or debit
Calculate aggregate credits and debits for each month
Display data after calculating totals at end of month. Averages are calculated by number of days in month and by number of transactions
Additionally, if CLI switch --ignoredonuts is entered, omit donut expenditure from debits calculation

------------------------------------
System requirements
------------------------------------
Install ruby v2.0.0 or higher
Install the following ruby gems
 - 'rest_client'
 - 'date'
 - 'time'
 - 'json'
 - 'optparse'

------------------------------------
Execution steps
------------------------------------
Download the zipped directory. For simplicity of this exercise, all required components are built in 'transactions.rb' file. Other resources are not necessary to run this program.

From Command line
Launch Terminal (or command prompt)
Navigate to folder containing transactions.rb file
run following commands and output will be displayed

1. To get all income and expenditure data for customer for a given month
 ruby transactions.rb

2. To get all income and expenditure data for customer for a given month ignoring donuts expense
 ruby transactions.rb --ignoredonuts