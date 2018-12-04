class TotalRankingTweetJob < ApplicationJob
  queue_as :default
  include FortunesHelper

  def perform
    require "slack"

    Slack.configure do |config|
      config.token = ENV['SLACK_TOKEN']
    end

    begin
      client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV['CONSUMER_API_KEY']
        config.consumer_secret     = ENV['CONSUMER_API_SECRET_KEY']
        config.access_token        = ENV['ACCESS_TOKEN']
        config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
      end

      @mezamashi = []
      @gudetama = []
      @sukkirisu = []
      @date = Date.today.beginning_of_day..Date.today.end_of_day
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

      string = ""
      for i in 0..2 do
        string += "めざまし占い★#{i+1}位\n" if @meza_result_1[i] == "t"
        string += "ぐでたま占い★#{i+1}位\n" if @gude_result_1[i] == "t"
      end

      string += "ゴーゴー星占い★総合1位\n" if @gogo_result_1[0] == "t"
      string += "ゴーゴー星占い★金運1位\n" if @gogo_result_1[1] == "t"
      string += "ゴーゴー星占い★恋愛運1位\n" if @gogo_result_1[2] == "t"
      string += "ゴーゴー星占い★仕事運1位\n" if @gogo_result_1[3] == "t"
      string += "ゴーゴー星占い★健康運1位\n" if @gogo_result_1[4] == "t"

      com = ["何かにチャレンジするなら今日かも！", "めっちゃいいかんじ！", "何かいいことがあるかも！", "努力が報われる日かも！", "今日は一日ハッピーな日です！"]
      comment = com.sample

      text = "【今日の占い総合ナンバーワンは？！】\n\n・・・★#{@overall_top3[0]}★のあなたです！\n\n#{string}\n#{comment}\n\n#今朝の占い\n\n他の星座もチェック！↓https://fortune-checker.supunic.com"
      client.update(text)

      Slack.chat_postMessage(
        channel: '#占いapp',
        text: "FortuneChecker\n12時のツイートが実行されました。"
      )
    rescue
      Slack.chat_postMessage(
        channel: '#占いapp',
        text: "FortuneChecker\n12時のツイートでエラーが発生しました。"
      )
    end
  end
end
