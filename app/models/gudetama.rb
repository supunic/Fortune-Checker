class Gudetama < ApplicationRecord
  # ぐでたま占い（はやドキ！/TBS/月〜金/ ）
  def self.gudetamaFortune(sign)
    sign_en = "ohitsuji" if sign == "おひつじ座"
    sign_en = "oushi" if sign == "おうし座"
    sign_en = "futago" if sign == "ふたご座"
    sign_en = "kani" if sign == "かに座"
    sign_en = "shishi" if sign == "しし座"
    sign_en = "otome" if sign == "おとめ座"
    sign_en = "tenbin" if sign == "てんびん座"
    sign_en = "sasori" if sign == "さそり座"
    sign_en = 'id="ite"' if sign == "いて座"
    sign_en = "yagi" if sign == "やぎ座"
    sign_en = "mizugame" if sign == "みずがめ座"
    sign_en = "uo" if sign == "うお座"

    @sign = sign
    page = Faraday.get('http://www.tbs.co.jp/hayadoki/gudetama/')
    page_ja = page.body.toutf8

    number = page_ja.index(sign_en)

    rank_num = page_ja.rindex('alt', number)
    start_num = page_ja.index('>', rank_num)
    end_num = page_ja.index('<', start_num)
    @rank = page_ja.slice(start_num+1..end_num-2).to_i

    uranai_text_num = page_ja.index('uranai_text', number)
    start_num = page_ja.index('>', uranai_text_num)
    end_num = page_ja.index('<', start_num)
    @text = page_ja.slice(start_num+1..end_num-1)

    if @rank == 12
      advice_text_num = page_ja.index('advice_text', number)
      start_num = page_ja.index('>', advice_text_num)
      end_num = page_ja.index('<', start_num)
      @advice = page_ja.slice(start_num+1..end_num-1)

      lucky_color_num = page_ja.index('lucky_color', number)
      start_num = page_ja.index('>', lucky_color_num)
      end_num = page_ja.index('<', start_num)
      @lucky_color = page_ja.slice(start_num+21..end_num-1)

      lucky_item_num = page_ja.index('lucky_item', number)
      start_num = page_ja.index('>', lucky_item_num)
      end_num = page_ja.index('<', start_num)
      @lucky_item = page_ja.slice(start_num+22..end_num-1)
    else
      @advice = ""

      lucky_color_num = page_ja.index('lucky_color', number)
      start_num = page_ja.index('>', lucky_color_num)
      end_num = page_ja.index('<', start_num)
      @lucky_color = page_ja.slice(start_num+9..end_num-1)

      lucky_item_num = page_ja.index('lucky_item', number)
      start_num = page_ja.index('>', lucky_item_num)
      end_num = page_ja.index('<', start_num)
      @lucky_item = page_ja.slice(start_num+10..end_num-1)
    end
    Gudetama.create(sign: @sign, rank: @rank, text: @text, lucky_color: @lucky_color, lucky_item: @lucky_item, advice: @advice)
  end
end
