class CreateGogototals < ActiveRecord::Migration[5.1]
  def change
    create_table :gogototals do |t|
      t.text :gold_no1, default: ""
      t.text :love_no1, default: ""
      t.text :work_no1, default: ""
      t.text :health_no1, default: ""
      t.timestamps
    end
  end
end
