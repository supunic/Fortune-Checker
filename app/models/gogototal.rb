class Gogototal < ApplicationRecord
  # ゴーゴー星占い（グッド！モーニング/テレビ朝日/月〜金/ ）
  def self.gogoFortuneTotal
    page = Faraday.get('https://www.tv-asahi.co.jp/goodmorning/uranai/')
    page_ja = page.body.toutf8

    number = page_ja.index('no1_corner')

    def self.change_ja(name)
      return "おひつじ座" if name == "ohitsujiza"
      return "おうし座" if name == "oushiza"
      return "ふたご座" if name == "hutagoza"
      return "かに座" if name == "kaniza"
      return "しし座" if name == "shishiza"
      return "おとめ座" if name == "otomeza"
      return "てんびん座" if name == "tenbinza"
      return "さそり座" if name == "sasoriza"
      return "いて座" if name == "iteza"
      return "やぎ座" if name == "yagiza"
      return "みずがめ座" if name == "miugameza"
      return "うお座" if name == "uoza"
    end

    # 総合 No1
    total_num = page_ja.index('total.gif', number)
    start_num = page_ja.index('no1', total_num)
    end_num = page_ja.index('.gif', start_num)
    total = page_ja.slice(start_num+4..end_num-1)
    @total = change_ja(total)

    # 金運 No1
    gold_num = page_ja.index('gold.gif', number)
    start_num = page_ja.index('no1', gold_num)
    end_num = page_ja.index('.gif', start_num)
    gold = page_ja.slice(start_num+4..end_num-1)
    @gold = change_ja(gold)

    # 恋愛運 No1
    love_num = page_ja.index('love.gif', number)
    start_num = page_ja.index('no1', love_num)
    end_num = page_ja.index('.gif', start_num)
    love = page_ja.slice(start_num+4..end_num-1)
    @love = change_ja(love)

    # 仕事運 No1
    work_num = page_ja.index('work.gif', number)
    start_num = page_ja.index('no1', work_num)
    end_num = page_ja.index('.gif', start_num)
    work = page_ja.slice(start_num+4..end_num-1)
    @work = change_ja(work)

    # 健康運 No1
    helth_num = page_ja.index('helth.gif', number)
    start_num = page_ja.index('no1', helth_num)
    end_num = page_ja.index('.gif', start_num)
    health = page_ja.slice(start_num+4..end_num-1)
    @health = change_ja(health)

    Gogototal.create(total_no1: @total, gold_no1: @gold, love_no1: @love, work_no1: @work, health_no1: @health)
  end
end
