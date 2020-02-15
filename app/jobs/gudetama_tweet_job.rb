class GudetamaTweetJob < ApplicationJob
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
          Gudetama.gudetamaFortune(sign)
        end
        # Slack.chat_postMessage(
        #   channel: '#占いapp',
        #   text: "FortuneChecker\nぐでたま占いのスクレイピング処理が完了しました。"
        # )
      rescue
        # Slack.chat_postMessage(
        #   channel: '#占いapp',
        #   text: "FortuneChecker\nぐでたま占いのスクレイピング処理でエラーが発生しました。"
        # )
      end

      client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV['CONSUMER_API_KEY']
        config.consumer_secret     = ENV['CONSUMER_API_SECRET_KEY']
        config.access_token        = ENV['ACCESS_TOKEN']
        config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
      end

      today = Date.today.beginning_of_day..Date.today.end_of_day
      fortunes = Gudetama.where(created_at: today).order(:rank)

      text = "【#{fortunes.last.created_at.strftime('%m/%d')} ぐでたま占いランキング】\n\n"
      fortunes.each do |f|
        if f.rank == 1 || f.rank == 2
          text += "#{f.rank}位★#{f.sign}\n"
        elsif f.rank == 3
          text += "#{f.rank}位★#{f.sign}\n\n"
        else
          text += "#{f.rank}位:#{f.sign}\n"
        end
      end
      text += "\n#今朝の占い\n\n詳細はこちら↓https://fortune-checker.supunic.com"

      # client.update(text)

      # Slack.chat_postMessage(
      #   channel: '#占いapp',
      #   text: "FortuneChecker\nぐでたま占いのツイートが完了しました。"
      # )
    rescue
      # Slack.chat_postMessage(
      #   channel: '#占いapp',
      #   text: "FortuneChecker\nぐでたま占いのツイートでエラーが発生しています。"
      # )
    end
  end
end
