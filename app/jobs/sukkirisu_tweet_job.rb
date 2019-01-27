class SukkirisuTweetJob < ApplicationJob
  queue_as :default

  def perform
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['CONSUMER_API_KEY']
      config.consumer_secret     = ENV['CONSUMER_API_SECRET_KEY']
      config.access_token        = ENV['ACCESS_TOKEN']
      config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
    end

    today = Date.today.beginning_of_day..Date.today.end_of_day
    fortunes = Sukkirisu.where(created_at: today).order(:rank)

    text = "【#{fortunes.last.created_at.strftime('%m/%d')} スッキりす占いランキング】\n\n"
    fortunes.each do |f|
      if f.rank == 1 || f.rank == 2 || f.rank == 3
        text += "★#{f.rank}位:#{f.sign}\n"
      else
        text += "#{f.rank}位:#{f.sign}\n"
      end
    end
    text += "\n#今朝の占い\n\n詳細はこちら↓https://fortune-checker.supunic.com"

    # client.update(text)
  end
end
