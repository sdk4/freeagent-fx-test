require 'sinatra'
require 'fx'
require 'slim'
require 'bigdecimal'

@@currencies = FX::ExchangeRate.currencies
@@dates = FX::ExchangeRate.dates

get '/' do
  slim :index
end

post '/' do
  @date = params[:date]
  @from = params[:from]
  @to = params[:to]
  @amount = BigDecimal.new(params[:amount])
  @result = (FX::ExchangeRate.at(@date, @from, @to) * @amount).round(2).to_s('F')
  @result = @amount if @from == @to
  @amount = @amount.to_s('F')
  slim :index
end

get('/styles.css'){ content_type 'text/css', :charset => 'utf-8' ; scss :styles }
