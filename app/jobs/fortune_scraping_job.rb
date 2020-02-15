class FortuneScrapingJob < ApplicationJob
  queue_as :default

  def perform
    require 'faraday'
    require 'kconv'
    require "slack"

    Slack.configure do |config|
      config.token = ENV['SLACK_TOKEN']
    end

    begin
      # 星座占いまとめ
      signs = ["おひつじ座", "おうし座", "ふたご座", "かに座", "しし座", "おとめ座", "てんびん座", "さそり座", "いて座", "やぎ座", "みずがめ座", "うお座"]

      # めざまし占い
      signs.each do |sign|
        Mezamashi.mezamashiFortune(sign)
      end

      # すっきりす占い
      for month in 1..12 do
        Sukkirisu.sukkirisuFortune(month)
      end

      # Slackにメッセージ送信
      Slack.chat_postMessage(
        channel: '#占いapp',
        text: "FortuneChecker\nめざまし・すっきりす占いのスクレイピングが実行されました。"
      )

      # Tweet Jobの起動
      begin
        TweetJob.perform_later
        Slack.chat_postMessage(
          channel: '#占いapp',
          text: "FortuneChecker\nメインツイートが実行されました。"
        )
      rescue
        Slack.chat_postMessage(
          channel: '#占いapp',
          text: "FortuneChecker\nメインツイートにエラーが発生しています。"
        )
      end
    rescue
      # Slackにメッセージ送信
      Slack.chat_postMessage(
        channel: '#占いapp',
        text: "FortuneChecker\nめざまし・すっきりす占いのスクレイピングにエラーが発生しています。"
      )
    end
  end
end
