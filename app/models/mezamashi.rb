class Mezamashi < ApplicationRecord
  # めざまし占い（めざましテレビ/フジ/月〜土/8時更新 ※土のみ8時半更新）
  def self.mezamashiFortune()
    page = Faraday.get("https://www.fujitv.co.jp/meza/uranai/data/uranai.json")
    uranaiJson = JSON.load(page.body.toutf8)
    
    uranaiJson['ranking'].each do |ranking|
      @sign = ranking['name']
      @rank = ranking['rank']
      @text1 = ranking['text']
      @lucky_point = ranking['point']
      @advice = ranking['advice']
      Mezamashi.create(sign: @sign, rank: @rank, text1: @text1, lucky_point: @lucky_point, advice: @advice)
    end
  end
end
