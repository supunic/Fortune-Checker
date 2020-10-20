set :output, "log/scraping.log"
set :environment, :production

# ゴーゴー占いスクレイピング処理＆ツイート
every :weekday, at: '5:10 am' do
  runner 'GogoTweetJob.perform_later'
end

# ぐでたま占いスクレイピング処理＆ツイート
every :weekday, at: '6:00 am' do
  runner 'GudetamaTweetJob.perform_later'
end

# めざまし・すっきりすスクレイピング処理＆メインツイート
every :weekday, at: '8:03 am' do
  runner 'FortuneScrapingJob.perform_later'
end

# 総合一位ツイート処理（追加）
every :weekday, at: '12:00 pm' do
  runner 'TotalRankingTweetJob.perform_later'
end

# データベース削除処理
every :weekday, at: '8:10 am' do
  runner 'FortuneDeleteJob.perform_later'
end
