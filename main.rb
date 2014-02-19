require 'sinatra'
require 'exchange_rate'
require 'slim'

get '/' do
  @currencies = ['usd', 'gbp']
  @dates = ExchangeRate::dates
  slim :index
end

post '/' do
  redirect to('/')
end

get('/styles.css'){ content_type 'text/css', :charset => 'utf-8' ; scss :styles }
