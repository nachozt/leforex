class AddIndexToBank < ActiveRecord::Migration[6.0]
  def change
    add_index :institutions, :bank
    change_column_null :institutions, :bank, false
  end
end
