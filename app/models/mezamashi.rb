class Mezamashi < ApplicationRecord
  # めざまし占い（めざましテレビ/フジ/月〜土/8時更新 ※土のみ8時半更新）
  def self.mezamashiFortune(sign)
    @sign = sign

    id = "<id>01</id>" if @sign == "おひつじ座"
    id = "<id>02</id>" if @sign == "おうし座"
    id = "<id>03</id>" if @sign == "ふたご座"
    id = "<id>04</id>" if @sign == "かに座"
    id = "<id>05</id>" if @sign == "しし座"
    id = "<id>06</id>" if @sign == "おとめ座"
    id = "<id>07</id>" if @sign == "てんびん座"
    id = "<id>08</id>" if @sign == "さそり座"
    id = "<id>09</id>" if @sign == "いて座"
    id = "<id>10</id>" if @sign == "やぎ座"
    id = "<id>11</id>" if @sign == "みずがめ座"
    id = "<id>12</id>" if @sign == "うお座"

    date = Date.today.strftime("%Y%m%d")
    page = Faraday.get("https://www.fujitv.co.jp/meza/uranai/uranai.xml?#{date}")
    page_ja = page.body.toutf8

    number = page_ja.index(id)

    rank_num = page_ja.rindex('rank', number)
    first_rank_num = page_ja.rindex('rank', rank_num-1)
    start_num = page_ja.index('>', first_rank_num)
    end_num = page_ja.index('<', start_num)
    @rank = page_ja.slice(start_num+1..end_num-2).to_i

    text_num = page_ja.index('text', number)
    start_num = page_ja.index('>', text_num)
    end_num = page_ja.index('<', start_num)
    @text1 = page_ja.slice(start_num+1..end_num-1)

    lucky_point_num = page_ja.index('point', number)
    start_num = page_ja.index('>', lucky_point_num)
    end_num = page_ja.index('<', start_num)
    @lucky_point = page_ja.slice(start_num+1..end_num-1)

    advice_num = page_ja.index('advice', number)
    start_num = page_ja.index('>', advice_num)
    end_num = page_ja.index('<', start_num)

    if start_num+1 == end_num
      @advice = ""
      @good_luck_charm = ""
    else
      if @rank == 12
        @advice = ""
        @good_luck_charm = page_ja.slice(start_num+1..end_num-1)
      elsif @rank == 1
        @advice = page_ja.slice(start_num+1..end_num-1)
        @good_luck_charm = ""
      end
    end

    Mezamashi.create(sign: @sign, rank: @rank, text1: @text1, lucky_point: @lucky_point, advice: @advice, good_luck_charm: @good_luck_charm)
  end
end
