class FortuneDeleteJob < ApplicationJob
  queue_as :default

  def perform
    date = Date.today.prev_month(1).beginning_of_day..Date.today.prev_month(1).end_of_day

    Mezamashi.where(created_at: date).delete if Mezamashi.where(created_at: date).exists?
    Gudetama.where(created_at: date).delete if Gudetama.where(created_at: date).exists?
    Gogo.where(created_at: date).delete if Gogo.where(created_at: date).exists?
    Sukkirisu.where(created_at: date) if Sukkirisu.where(created_at: date).exists?
    Gogototal.where(created_at: date) if Gogototal.where(created_at: date).exists?
  end
end
