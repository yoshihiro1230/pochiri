# -*- coding: utf-8 -*-
require 'anemone'
require 'nokogiri'
require 'kconv'

# クロールの起点URLを指定
urls = ["http://www.amazon.co.jp/gp/bestsellers/"]

# 巡回サイトのURLを指定
Anemone.crawl(urls, :depth_limit => , :skip_query_strings => true) do |anemone|

    # 除外対象ページのURLパターンを指定

    # 巡回対象ページのURLを指定
    anemone.focus_crawl do |page|
        page.links.keep_if { |link|
            link.to_s.match(/\/gp\/bestsellers/)
        }
    end

    # 正規表現で一致したページのみ処理
    # すべてのページに対する処理
    anemone.on_every_page do |page|
        doc = Nokogiri::HTML.parse(page.body.toutf8)
        titles = doc.xpath("//*[@id=\"zg_left_col1\"]//div[3]/span[1]/a")
        reviews = doc.xpath("//*[@id=\"zg_left_col1\"]//span[2]/a")
        titles.each {|t|
          puts t.text
        }
        reviews.each {|r|
          puts r.text
        }
      end

end
