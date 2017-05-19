class AddNewFieldsToMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :date, :string
    add_column :messages, :read, :bool
    add_column :messages, :star, :bool
  end
end
