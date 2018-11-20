class CreateMezamashis < ActiveRecord::Migration[5.1]
  def change
    create_table :mezamashis do |t|
      t.string :sign
      t.integer :rank
      t.text :text1, default: ""
      t.text :text2, default: ""
      t.text :lucky_point, default: ""
      t.text :advice, default: ""
      t.text :good_luck_charm, default: ""
      t.timestamps
    end
  end
end
