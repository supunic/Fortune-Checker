class CreateSukkirisus < ActiveRecord::Migration[5.1]
  def change
    create_table :sukkirisus do |t|
      t.integer :month
      t.integer :rank
      t.text :text, default: ""
      t.text :lucky_color, default: ""
      t.timestamps
    end
  end
end
