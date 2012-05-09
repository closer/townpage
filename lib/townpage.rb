require "mechanize"

module TownPage

  class Searches

    def initialize params={}
      @params = params
    end

    def search
      searches = []
      results = Results.new
    end
  end

  class Results
    def companies
    end
  end

  class Base
    @@agent = Mechanize.new
  end

  class Search < Base

    attr_accessor :params

    @@dir_result = 'http://itp.ne.jp/dir_result/'

    @@default_options = {'num' => 50}

    def initialize params={}
      @params = @@default_options.merge params
    end

    def search
      Result.new @@agent.get( "#{@@dir_result}?#{@params.map{|k,v| "#{k}=#{v}"}.join('&')}" )
    end
  end

  class Result < Base

    attr_reader :total

    def initialize page
      @current_page = page
      @total = page.search('h1[class^=hdg-level] span').text.to_i
    end

    def companies
      results = []
      begin
        @current_page.search('div[class^=box-shop]').each do |box|
          results << Company.new(box)
        end
        puts "#{(results.size.to_f / @total.to_f * 100).to_i} %"
      end while next_page
      return results
    end

    def next_page
      sleep 1
      unless anchor = @current_page.search('li.next a').first
        return false
      else
        @current_page = @@agent.get(anchor.attr("href"))
      end
    end
  end

  class Company

    def initialize div
      @elm = div
    end

    def name
      @elm.search('.heading h2').text
    end

    def address
      @elm.search('table tr:first td').text
    end

    def tel
      @elm.search('table tr:last td').text
    end
  end
end


