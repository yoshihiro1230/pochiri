require 'nokogiri'
require 'anemone'

opts = {
	depth_limit: 1
		# 0 => 指定したURL先のみ
		# 1 => 指定したURLにあるlinkから辿れる先も見る。
}

Anemone.crawl("http://www.amazon.co.jp/gp/bestsellers", opts) do |anemone|

	# 起点となるページから飛ぶ先を予め指定
	anemone.focus_crawl do |page|
		page.links.keep_if{|link| link.to_s.match(/http:\/\/www.amazon.co.jp\/gp\/bestsellers\//)}
	end

	# まずは起点ページの地域別賃料を取得
	anemone.on_pages_like(%r[http://www.amazon.co.jp/gp/bestsellers/]) do |page|
		page.doc.xpath("/html//div[@class='zg_itemRow\']//tbody[@id='zg_itemRow']/tr").each do |node|
			title  = node.xpath("./div[@class=\"zg_itemRow\"]/div[1]/div[2]").to_s
			price = node.xpath(".div[@class=\"zg_itemRow\"]/div[1]/div[2]").to_s

			puts title + "," + price + "万円\n"
		end
	end
=begin
	anemone.on_pages_like(/http:\/\/www.homes.co.jp\/chintai\/tokyo\/[a-z]*-city\/price\//) do |page|
		# 地名を取得
		print page.doc.xpath("/html/body//h2/span[@class='key']/text()").to_s
		# 地域別賃料と同様の方法でリスト化
		page.doc.xpath("/html//div[@class='priceList']//tbody[@id='prg-aggregate-graph']/tr").each do |node|
			madori  = node.xpath("./td[@class='madori']/text()").to_s
			price = node.xpath("./td[contains(@class,'price')]/div[contains(@class,'money')]/span/text()").to_s
			# 金額表示無しが目立ったので、priceが空欄の時にはなしと表示
			if price != ""
				puts "," + madori + "," + price + "万円\n"
			else
				puts "," + madori + "," + price + "なし\n"
			end
		end
	end
=end
end
