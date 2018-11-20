class Mezamashi < ApplicationRecord
  # めざまし占い（めざましテレビ/フジ/月〜土/8時更新 ※土のみ8時半更新）
  def self.mezamashiFortune(sign)
    @sign = sign
    page = Faraday.get('http://fcs2.sp2.fujitv.co.jp/fortune.php')
    page_ja = page.body.toutf8

    number = page_ja.index(sign)

    rank_num = page_ja.rindex('rank', number)
    start_num = page_ja.index('>', rank_num)
    end_num = page_ja.index('<', start_num)
    @rank = page_ja.slice(start_num+1..end_num-2).to_i

    wordBgnng_num = page_ja.index('wordBgnng', number)
    start_num = page_ja.index('>', wordBgnng_num)
    end_num = page_ja.index('<', start_num)
    @text1 = page_ja.slice(start_num+1..end_num-1)

    start_num = page_ja.index('>', end_num)
    end_num = page_ja.index('<', start_num)
    @text2 = page_ja.slice(start_num+1..end_num-1)

    if page_ja.index('ラッキーポイント', number).present? && page_ja.index('ラッキーポイント', number) < page_ja.index('fortunerank', number)
      lucky_point_num = page_ja.index('ラッキーポイント', number)
      lucky_point_td_num = page_ja.index('<td>', lucky_point_num)
      start_num = page_ja.index('>', lucky_point_td_num)
      end_num = page_ja.index('<', start_num)
      @lucky_point = page_ja.slice(start_num+1..end_num-1)
    end

    if page_ja.index('アドバイス', number).present? && page_ja.index('アドバイス', number) < page_ja.index('fortunerank', number)
      advice_num = page_ja.index('アドバイス', number)
      advice_td_num = page_ja.index('<td>', advice_num)
      start_num = page_ja.index('>', advice_td_num)
      end_num = page_ja.index('<', start_num)
      @advice = page_ja.slice(start_num+1..end_num-1)
    else
      @advice = ""
    end

    if page_ja.index('おまじない', number).present? && page_ja.index('おまじない', number) < page_ja.index('fortunerank', number)
      good_luck_charm_num = page_ja.index('おまじない', number)
      good_luck_charm_td_num = page_ja.index('<td>', good_luck_charm_num)
      start_num = page_ja.index('>', good_luck_charm_td_num)
      end_num = page_ja.index('<', start_num)
      @good_luck_charm = page_ja.slice(start_num+1..end_num-1)
    else
      @good_luck_charm = ""
    end

    Mezamashi.create(sign: @sign, rank: @rank, text1: @text1, text2: @text2, lucky_point: @lucky_point, advice: @advice, good_luck_charm: @good_luck_charm)
  end
end
