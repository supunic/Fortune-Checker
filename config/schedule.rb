set :output, "log/scraping.log"
set :environment, :production

# スクレイピング処理
every :weekday, at: '8:05 am' do
  runner 'FortuneScrapingJob.perform_later'
end

# ツイート処理 → スクレイピング処理成功時に移動
every :weekday, at: '8:08 am' do
  runner 'TweetJob.perform_later'
end

# 総合一位ツイート処理（追加）
every :weekday, at: '12:00 pm' do
  runner 'TotalRankingTweetJob.perform_later'
end

# データベース削除処理
every :weekday, at: '8:10 am' do
  runner 'FortuneDeleteJob.perform_later'
end
