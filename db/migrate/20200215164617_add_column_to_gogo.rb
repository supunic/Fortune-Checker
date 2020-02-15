class AddColumnToGogo < ActiveRecord::Migration[5.1]
  def change
    add_column :gogos, :rank, :integer
  end
end
