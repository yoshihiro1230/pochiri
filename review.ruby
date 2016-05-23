require 'anemone'
require 'nokogiri'
require 'kconv'

urls = []
urls.push("http://www.amazon.co.jp/gp/bestsellers/sports/ref=zg_bs_unv_sg_1_344920011_2")

Anemone.crawl(urls, :depth_limit => 0) do |anemone|
    anemone.on_every_page do |page|

    #文字コードをUTF8に変換したうえで、Nokogiriでパース
    doc = Nokogiri::HTML.parse(page.body.toutf8)

    items = doc.xpath("//div[@class=\"a-link-normal\"]/div[1]/div[2]")
    items.each{|item|

        puts item.xpath("div[\"a-link-normal\"]").text
    }
    end
end
