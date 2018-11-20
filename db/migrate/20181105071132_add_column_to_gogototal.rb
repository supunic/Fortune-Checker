class AddColumnToGogototal < ActiveRecord::Migration[5.1]
  def change
    add_column :gogototals, :total_no1, :text, default: ""
  end
end
