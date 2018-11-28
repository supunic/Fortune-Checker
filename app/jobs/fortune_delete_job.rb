class FortuneDeleteJob < ApplicationJob
  queue_as :default

  def perform
    begin
      date = Date.today.prev_month(1).beginning_of_day..Date.today.prev_month(1).end_of_day

      Mezamashi.where(created_at: date).delete_all if Mezamashi.where(created_at: date).exists?
      Gudetama.where(created_at: date).delete_all if Gudetama.where(created_at: date).exists?
      Gogo.where(created_at: date).delete_all if Gogo.where(created_at: date).exists?
      Sukkirisu.where(created_at: date).delete_all if Sukkirisu.where(created_at: date).exists?
      Gogototal.where(created_at: date).delete_all  if Gogototal.where(created_at: date).exists?
    rescue
      # Slackにメッセージ送信
      Slack.chat_postMessage(
        channel: '#占いapp',
        text: "FortuneChecker\nデータ削除にエラーが発生しています。"
      )
    end
  end
end
