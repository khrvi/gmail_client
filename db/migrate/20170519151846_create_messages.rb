class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.string :message_id
      t.string :from
      t.string :to
      t.string :subject
      t.string :label
      t.text :body

      t.timestamps
    end
  end
end
