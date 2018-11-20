class CreateGogos < ActiveRecord::Migration[5.1]
  def change
    create_table :gogos do |t|
      t.string :sign
      t.integer :kinun
      t.integer :renai
      t.integer :shigoto
      t.integer :kenko
      t.text :text, default: ""
      t.text :lucky_color, default: ""
      t.text :lucky_item, default: ""
      t.timestamps
    end
  end
end
