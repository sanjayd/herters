require 'json'
require 'nokogiri'

URL = 'http://www.cabelas.com/product/Hertersreg-Field-and-Target-Loads-150-Per-Case/1545677.uts?Ntk=AllProducts&searchPath=%2Fcatalog%2Fsearch%2F%3FN%3D5100191%26Ne%3D5100191%26Ntk%3DAllProducts%26Ntt%3DHerter%2527s%26Ntx%3Dmode%252Bmatchallpartial%26WT.mc_id%3Dherters.com%26WT.tsrc%3DDRD%26WTz_st%3DSearchRefinements%26form_state%3DsearchForm%26search%3DHerter%2527s%26searchTypeByFilter%3DAllProducts%26x%3D0%26y%3D0&Ntt=Herter%27s&WTz_l='
SALES = 'sales.json'

doc = Nokogiri::XML(`curl -s #{URL}`)

sales = doc.css('td dl.salePrice').find_all {|node| node.children.size > 1}
prices = sales.map do |sale|
  row = sale.ancestors('tr')
  row.css('td')[0 .. 4].map {|td| td.text} << sale.css('dd.saleprice').text
end

hash = {:prices => prices, :updated => `date`.strip}
File.open(SALES, 'w') {|f| f.puts hash.to_json}
