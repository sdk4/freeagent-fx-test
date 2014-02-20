require 'sinatra'
require 'fx'
require 'slim'
  @@currencies = FX::ExchangeRate.currencies
  @@dates = FX::ExchangeRate.dates
get '/' do
  slim :index
end

post '/' do
  @date = params[:date]
  @from = params[:from]
  @to = params[:to]
  @amount = params[:amount].to_d
  @result = FX::ExchangeRate.at(@date, @from, @to) * @amount
  @result = @amount if @from == @to
  @currencies = FX::ExchangeRate.currencies
  @dates = FX::ExchangeRate.dates
  slim :index
end

get('/styles.css'){ content_type 'text/css', :charset => 'utf-8' ; scss :styles }
