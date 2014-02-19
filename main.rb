require 'sinatra'
require './exchangerate.rb'
require 'slim'

@exchange = ExchangeRate.new()

get '/' do
  @currencies = ['usd', 'gbp']
  @dates = @exchange.dates
  slim :index
end

post '/' do
  redirect to('/')
end



get('/styles.css'){ content_type 'text/css', :charset => 'utf-8' ; scss :styles }
