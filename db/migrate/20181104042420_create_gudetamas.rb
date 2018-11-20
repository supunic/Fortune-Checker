class CreateGudetamas < ActiveRecord::Migration[5.1]
  def change
    create_table :gudetamas do |t|
      t.string :sign
      t.integer :rank
      t.text :text, default: ""
      t.text :lucky_color, default: ""
      t.text :lucky_item, default: ""
      t.text :advice, default: ""
      t.timestamps
    end
  end
end
