class Gogo < ApplicationRecord
  # ゴーゴー星占い（グッド！モーニング/テレビ朝日/月〜金/ ）
  def self.gogoFortune(sign)
    sign_en = "ohitsujiza" if sign == "おひつじ座"
    sign_en = "oushiza" if sign == "おうし座"
    sign_en = "hutagoza" if sign == "ふたご座"
    sign_en = "kaniza" if sign == "かに座"
    sign_en = "shishiza" if sign == "しし座"
    sign_en = "otomeza" if sign == "おとめ座"
    sign_en = "tenbinza" if sign == "てんびん座"
    sign_en = "sasoriza" if sign == "さそり座"
    sign_en = "iteza" if sign == "いて座"
    sign_en = "yagiza" if sign == "やぎ座"
    sign_en = "miugameza" if sign == "みずがめ座"
    sign_en = "uoza" if sign == "うお座"

    @sign = sign
    page = Faraday.get('https://www.tv-asahi.co.jp/goodmorning/uranai/')
    page_ja = page.body.toutf8

    number = page_ja.index(sign_en)

    yokoku_num = page_ja.index('yokoku', number)
    start_num = page_ja.index('>', yokoku_num)
    end_num = page_ja.index('<', start_num)
    @yokoku = page_ja.slice(start_num+1..end_num-1)

    color_b_num1 = page_ja.index('color_b', number)
    start_num = page_ja.index('>', color_b_num1)
    end_num = page_ja.index('<', start_num)
    @color_b1 = page_ja.slice(start_num+1..end_num-1)

    color_b_num2 = page_ja.index('color_b', color_b_num1+1)
    start_num = page_ja.index('>', color_b_num2)
    end_num = page_ja.index('<', start_num)
    @color_b2 = page_ja.slice(start_num+1..end_num-1)

    # 金運カウンター
    # kinun_num = page_ja.index('kinun.gif', number)
    money_num = page_ja.index('money.gif', number)
    @kinun_count = 0
    while money_num < color_b_num2
      @kinun_count += 1
      if page_ja.index('money.gif', money_num+1)
        money_num = page_ja.index('money.gif', money_num+1)
      else
        break
      end
    end

    # 恋愛運カウンター
    # renai_num = page_ja.index('renai.gif', number)
    love_num = page_ja.index('love.gif', number)
    @renai_count = 0
    while love_num < color_b_num2
      @renai_count += 1
      if page_ja.index('love.gif', love_num+1)
        love_num = page_ja.index('love.gif', love_num+1)
      else
        break
      end
    end

    # 仕事運カウンター
    # shigoto_num = page_ja.index('shigoto.gif', number)
    work_num = page_ja.index('work.gif', number)
    @shigoto_count = 0
    while work_num < color_b_num2
      @shigoto_count += 1
      if page_ja.index('work.gif', work_num+1)
        work_num = page_ja.index('work.gif', work_num+1)
      else
        break
      end
    end

    # 健康運カウンター
    # kenko_num = page_ja.index('kenko.gif', number)
    health_num = page_ja.index('health.gif', number)
    @kenko_count = 0
    while health_num < color_b_num2
      @kenko_count += 1
      if page_ja.index('health.gif', health_num+1)
        health_num = page_ja.index('health.gif', health_num+1)
      else
        break
      end
    end

    Gogo.create(sign: @sign, kinun: @kinun_count, renai: @renai_count, shigoto: @shigoto_count, kenko: @kenko_count, text: @yokoku, lucky_color: @color_b1, lucky_item: @color_b2)
  end
end
