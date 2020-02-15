class Gogototal < ApplicationRecord
  # ゴーゴー星占い（グッド！モーニング/テレビ朝日/月〜金/ ）
  def self.gogoFortuneTotal
    # set up
    page = Faraday.get('https://www.tv-asahi.co.jp/goodmorning/uranai/')
    @page_ja = page.body.toutf8
    @no1_area_index = @page_ja.index('"no1-area"')

    # function
    def self.getSign(target)
      target_index = @page_ja.index(target, @no1_area_index)
      lucky_box_index = @page_ja.index('lucky-box', target_index)
      start_index = @page_ja.index('>', lucky_box_index)
      end_index = @page_ja.index('<', start_index)

      return @page_ja.slice(start_index + 1 .. end_index - 1)
    end

    # scraping
    @total = getSign('images/lucky-total')
    @gold = getSign('images/lucky-money')
    @love = getSign('images/lucky-love')
    @work = getSign('images/lucky-work')
    @health = getSign('images/lucky-health')

    # create
    Gogototal.create(
      total_no1: @total,
      gold_no1: @gold,
      love_no1: @love,
      work_no1: @work,
      health_no1: @health
    )
  end
end
