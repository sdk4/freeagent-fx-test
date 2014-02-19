module FX
  require 'nokogiri'
  require 'date'

  class ExchangeRate

    #read local xml file
    f = File.open("rates.xml")
    @doc = Nokogiri::XML(f)
    f.close()

    def self.at(date=Date.today, from, to)
      #get xml at date
      test = @doc.xpath("//*[local-name() = 'Cube'][@time='#{date}']")
      date = dates().first.value if test.empty?   #use last known date if no data
      #get from value
      from_node = @doc.at_xpath("//*[local-name() = 'Cube'][@time='#{date}']/*[local-name() = 'Cube'][@currency='#{from.upcase}']/@rate")
      raise "currency not found: #{from}" if from_node.nil?

      #get to value
      to_node = @doc.at_xpath("//*[local-name() = 'Cube'][@time='#{date}']/*[local-name() = 'Cube'][@currency='#{to.upcase}']/@rate")
      raise "currency not found: #{to}" if to_node.nil?

      #return currency value
      (to_node.value.to_f/from_node.value.to_f)
    end

    def self.currencies(date=Date.today)
      test = @doc.xpath("//*[local-name() = 'Cube'][@time='#{date}']")
      if test.empty?
        date = dates().first.value #use last known date if no data
        test = @doc.xpath("//*[local-name() = 'Cube'][@time='#{date}']")
      end
      currency_arr = []
      test.children.to_a.each { |x| currency_arr << x.attr("currency")}
      currency_arr
    end

    def self.dates
      @doc.xpath("//@time")
    end

  end
end
