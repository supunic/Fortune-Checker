class FortunesController < ApplicationController
  include FortunesHelper
  before_action :set_date

  def index
    @mezamashi = []
    @gudetama = []
    @sukkirisu = []
    @gogototal_fortune = Gogototal.where(created_at: @date).first

    for i in 1..3 do
      @mezamashi << Mezamashi.where(created_at: @date).find_by(rank: i)
      @gudetama << Gudetama.where(created_at: @date).find_by(rank: i)
      @sukkirisu << Sukkirisu.where(created_at: @date).find_by(rank: i)
    end

    @gogo_total_no1 = Gogo.where(created_at: @date).find_by(sign: @gogototal_fortune.total_no1)
    @gogo_gold_no1 = Gogo.where(created_at: @date).find_by(sign: @gogototal_fortune.gold_no1)
    @gogo_love_no1 = Gogo.where(created_at: @date).find_by(sign: @gogototal_fortune.love_no1)
    @gogo_work_no1 = Gogo.where(created_at: @date).find_by(sign: @gogototal_fortune.work_no1)
    @gogo_health_no1 = Gogo.where(created_at: @date).find_by(sign: @gogototal_fortune.health_no1)

    overall_ranking_array = {}
    signs = ["おひつじ座", "おうし座", "ふたご座", "かに座", "しし座", "おとめ座", "てんびん座", "さそり座", "いて座", "やぎ座", "みずがめ座", "うお座"]
    signs.each do |sign|
      sum = overallRanking(sign)
      overall_ranking_array.store(sign, sum)
    end

    @overall_top3 = []

    overall_ranking_array.sort{|(sign1, sum1), (sign2, sum2)| sum2 <=> sum1}[0, 3].each do |key, value|
      @overall_top3 << key
    end

    fortune_result(@overall_top3[0])
    @meza_result_1 = @meza_result
    @gude_result_1 = @gude_result
    @gogo_result_1 = @gogo_result

    fortune_result(@overall_top3[1])
    @meza_result_2 = @meza_result
    @gude_result_2 = @gude_result
    @gogo_result_2 = @gogo_result

    fortune_result(@overall_top3[2])
    @meza_result_3 = @meza_result
    @gude_result_3 = @gude_result
    @gogo_result_3 = @gogo_result

    # ゴーゴー占い更新後の表示用
    gogo_date = Gogo.last.created_at.beginning_of_day..Gogo.last.created_at.end_of_day if Gogo.last.created_at != @date
    @gogototal_fortune = Gogototal.where(created_at: gogo_date).first
    @gogo_total_no1 = Gogo.where(created_at: gogo_date).find_by(sign: @gogototal_fortune.total_no1)
    @gogo_gold_no1 = Gogo.where(created_at: gogo_date).find_by(sign: @gogototal_fortune.gold_no1)
    @gogo_love_no1 = Gogo.where(created_at: gogo_date).find_by(sign: @gogototal_fortune.love_no1)
    @gogo_work_no1 = Gogo.where(created_at: gogo_date).find_by(sign: @gogototal_fortune.work_no1)
    @gogo_health_no1 = Gogo.where(created_at: gogo_date).find_by(sign: @gogototal_fortune.health_no1)

    # ぐでたま占い更新後の表示用
    gudetama_date = Gudetama.last.created_at.beginning_of_day..Gudetama.last.created_at.end_of_day if Gudetama.last.created_at != @date
    @gudetama = []
    for i in 1..3 do
      @gudetama << Gudetama.where(created_at: gudetama_date).find_by(rank: i)
    end
  end

  def show
    gogo_date = Gogo.last.created_at.beginning_of_day..Gogo.last.created_at.end_of_day if Gogo.last.created_at != @date
    gudetama_date = Gudetama.last.created_at.beginning_of_day..Gudetama.last.created_at.end_of_day if Gudetama.last.created_at != @date

    @sign = params_change(params[:id])
    @mezamashi_sign_fortune = Mezamashi.where(created_at: @date).find_by(sign: @sign)
    @gogo_sign_fortune = Gogo.where(created_at: gogo_date).find_by(sign: @sign)
    @gudetama_sign_fortune = Gudetama.where(created_at: gudetama_date).find_by(sign: @sign)
    @gogototal_fortune = Gogototal.where(created_at: gogo_date).first

    # 2/18 アマゾンAPI中止
    # @mezamashi_lucky_item = searchLuckyItemByAmazon(Mezamashi.where(created_at: @date).find_by(sign: @sign).lucky_point)
    # @gogo_lucky_item = searchLuckyItemByAmazon(Gogo.where(created_at: gogo_date).find_by(sign: @sign).lucky_item)
    # @gudetama_lucky_item = searchLuckyItemByAmazon(Gudetama.where(created_at: gudetama_date).find_by(sign: @sign).lucky_item)
  end

  def check
    if params[:id] == "mezamashi"
      @name = "めざまし占い"
      @fortunes = Mezamashi.where(created_at: @date).sort_by { |a| a[:id] }[0, 12].sort_by! { |a| a[:rank] }
    elsif params[:id] == "gudetama"
      @date = Gudetama.last.created_at.beginning_of_day..Gudetama.last.created_at.end_of_day if Gudetama.last.created_at != @date
      @name = "ぐでたま占い"
      @fortunes = Gudetama.where(created_at: @date).sort_by { |a| a[:id] }[0, 12].sort_by! { |a| a[:rank] }
    elsif params[:id] == "gogo"
      @date = Gogo.last.created_at.beginning_of_day..Gogo.last.created_at.end_of_day if Gogo.last.created_at != @date
      @name = "ゴーゴー星占い"
      @fortunes = Gogo.where(created_at: @date).sort_by { |a| a[:id] }[0, 12].sort_by! { |a| a[:rank] }
      @fortune_total = Gogototal.where(created_at: @date).first
    elsif params[:id] == "sukkirisu"
      @name = "スッキりす誕生月占い"
      @fortunes = Sukkirisu.where(created_at: @date).sort_by { |a| a[:id] }[0, 12].sort_by! { |a| a[:rank] }
    end
  end

  private

  def set_date
    today = Date.today.beginning_of_day..Date.today.end_of_day
    yesterday = Date.yesterday.beginning_of_day..Date.yesterday.end_of_day
    day_before_yasterday = Date.today.prev_day(2).beginning_of_day..Date.today.prev_day(2).end_of_day

    if Mezamashi.exists?(created_at: today)
      @date = today
    elsif Mezamashi.exists?(created_at: yesterday)
      @date = yesterday
    elsif Mezamashi.exists?(created_at: day_before_yasterday)
      @date = day_before_yasterday
    else
      @date = Mezamashi.last.created_at.beginning_of_day..Mezamashi.last.created_at.end_of_day
    end
  end
end
