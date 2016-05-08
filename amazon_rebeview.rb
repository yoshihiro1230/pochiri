require 'anemone'
require 'nokogiri'
require 'kconv'

urls = []
urls.push("http://www.amazon.co.jp/gp/site-directory")

Anemone.crawl(urls, :depth_limit => 1) do |anemone|
  PATTERN = %r[inside_bestsellers|bestsellers]
    anemone.on_pages_like(PATTERN) do |page|
    #文字コードをUTF8に変換したうえで、Nokogiriでパース
      doc = Nokogiri::HTML.parse(page.body.toutf8)

      category = doc.xpath("//*[@id='zg_browseRoot']/ul/li/a").text

      #カテゴリ名の表示
      sub_category = doc.xpath("//*[@id=\"zg_listTitle\"]/span").text
      puts category+"/"+sub_category

      items = doc.xpath("//div[@class=\"zg_itemRow\"]/div[1]/div[2]")
      items += doc.xpath("//div[@class=\"zg_itemRow\"]/div[2]/div[2]")
      items += doc.xpath("//a[@class=\"a-link-normal\"]/div[2]/div[2]")
      items.each{|item|

          # 順位
          puts item.xpath("div[1]/span[1]").text

          # 書名
          puts item.xpath("div[\"zg_title\"]/a").text

          # ASIN
          puts item.xpath("div[\"zg_title\"]/a")
              .attribute("href").text.match(%r{dp/(.+?)/})[1]
          }
          puts item.xpath("a[\"a-link-normal\"]/a").text
    end
end
