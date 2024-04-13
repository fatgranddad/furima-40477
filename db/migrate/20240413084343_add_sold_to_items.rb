class AddSoldToItems < ActiveRecord::Migration[7.0]
  def change
    add_column :items, :sold, :boolean, default: false, null: false
  end
end
