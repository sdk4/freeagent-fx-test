require 'sinatra'
require 'fx'
require 'slim'
require 'bigdecimal'

before do
  @@currencies ||= FX::ExchangeRate.currencies
  @@dates ||= FX::ExchangeRate.dates
end

get '/' do
  slim :index
end

post '/' do
  @date = params[:date]
  @from = params[:from]
  @to = params[:to]
  @amount = params[:amount]
  @result = (FX::ExchangeRate.at(@date, @from, @to) * BigDecimal.new(@amount)).round(2).to_s('F')
  @amount = comma_sep(@amount)
  @result = (@amount if @from == @to) || comma_sep(@result)
  slim :index
end

get('/styles.css'){ content_type 'text/css', :charset => 'utf-8' ; scss :styles }

def comma_sep(s)
  whole, decimal = s.split(".")
  whole_with_commas = whole.chars.to_a.reverse.each_slice(3).map(&:join).join(",").reverse
  [whole_with_commas, decimal].compact.join(".")
end
