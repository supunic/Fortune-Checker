set :output, "log/scraping.log"
set :environment, :development

# スクレイピング処理
every :weekday, at: '8:05 am' do
  runner 'FortuneScrapingJob.perform_later'
end

# ツイート処理
every :weekday, at: '8:08 am' do
  runner 'TweetJob.perform_later'
end

# データベース削除処理
every :weekday, at: '8:10 am' do
  runner 'FortuneDeleteJob.perform_later'
end
