class TweetJob < ApplicationJob
  queue_as :default

  def perform
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['CONSUMER_API_KEY']
      config.consumer_secret     = ENV['CONSUMER_API_SECRET_KEY']
      config.access_token        = ENV['ACCESS_TOKEN']
      config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
    end

    today = Date.today.beginning_of_day..Date.today.end_of_day
    m = []
    g = []
    s = []
    gt = Gogototal.where(created_at: today).first
    for i in 1..3 do
      m << Mezamashi.where(created_at: today).find_by(rank: i).sign
      g << Gudetama.where(created_at: today).find_by(rank: i).sign
      s << Sukkirisu.where(created_at: today).find_by(rank: i).month
    end

    text = "【#{gt.created_at.strftime('%m/%d')} 今朝の占いまとめ】\n\n★めざまし占い\n1位:#{m[0]}\n2位:#{m[1]}\n3位:#{m[2]}\n\n★ぐでたま占い\n1位:#{g[0]}\n2位:#{g[1]}\n3位:#{g[2]}\n\n★ゴーゴー占い\n総合1位:#{gt.total_no1}\n\n★スッキりす占い\n1位:#{s[0]}月\n2位:#{s[1]}月\n3位:#{s[2]}月\n\n#今朝の占い\n\n詳細はこちら↓https://fortune-checker.supunic.com"
    client.update(text)
  end
end
