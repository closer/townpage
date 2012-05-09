# -*- coding: utf-8 -*-

require "townpage"
require "csv"

CSV.open('results.csv', 'w') do |writer|
  TownPage::Search.new({'ad' => ARGV.shift, 'gr' => ARGV.shift}).search.companies.each do |company|
    writer << [company.name, company.address, company.tel]
  end
end

