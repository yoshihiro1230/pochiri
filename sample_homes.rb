require 'nokogiri'
require 'anemone'

opts = {
    depth_limit: 0
        # 0 => 指定したURL先のみ
        # 1 => 指定したURLにあるlinkから1回のジャンプで辿れる先も見る。
}

Anemone.crawl("http://www.homes.co.jp/chintai/tokyo/city/price/", opts) do |anemone|
    anemone.on_every_page do |page|
        page.doc.xpath("//div[@class='priceList']//tbody[@id='prg-aggregate-graph']/tr").each do |node|
            area  = node.xpath("./td[@class='area']/a/text()").to_s
            price = node.xpath("./td[contains(@class,’price’))]/div[@class='money']/span/text()").to_s
            puts area + "：" + price + "万円" # がっちゃんこ。
            puts "—————–\n"
        end
    end
end
