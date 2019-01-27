class GogoTweetJob < ApplicationJob
  queue_as :default

  def perform
    require 'faraday'
    require 'kconv'
    require "slack"

    Slack.configure do |config|
      config.token = ENV['SLACK_TOKEN']
    end

    begin
      signs = ["おひつじ座", "おうし座", "ふたご座", "かに座", "しし座", "おとめ座", "てんびん座", "さそり座", "いて座", "やぎ座", "みずがめ座", "うお座"]

      begin
        signs.each do |sign|
          Gogo.gogoFortune(sign)
        end
        Gogototal.gogoFortuneTotal
        Slack.chat_postMessage(
          channel: '#占いapp',
          text: "FortuneChecker\nゴーゴー占いのスクレイピング処理が完了しました。"
        )
      rescue
        Slack.chat_postMessage(
          channel: '#占いapp',
          text: "FortuneChecker\nゴーゴー占いのスクレイピング処理でエラーが発生しました。"
        )
      end

      client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV['CONSUMER_API_KEY']
        config.consumer_secret     = ENV['CONSUMER_API_SECRET_KEY']
        config.access_token        = ENV['ACCESS_TOKEN']
        config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
      end

      today = Date.today.beginning_of_day..Date.today.end_of_day
      fortune = Gogototal.where(created_at: today).first

      text = "【#{fortune.created_at.strftime('%m/%d')} ゴーゴー占いランキング】\n\n"
      text += "★総合1位★\n#{fortune.total_no1}\n\n"
      text += "金運1位★#{fortune.gold_no1}\n"
      text += "恋愛運1位★#{fortune.love_no1}\n"
      text += "仕事運1位★#{fortune.work_no1}\n"
      text += "健康運1位★#{fortune.health_no1}\n"
      text += "\n#今朝の占い\n\n詳細はこちら↓https://fortune-checker.supunic.com"

      client.update(text)

      Slack.chat_postMessage(
        channel: '#占いapp',
        text: "FortuneChecker\nゴーゴー占いのツイートが完了しました。"
      )
    rescue
      Slack.chat_postMessage(
        channel: '#占いapp',
        text: "FortuneChecker\nゴーゴー占いのツイートでエラーが発生しています。"
      )
    end
  end
end
