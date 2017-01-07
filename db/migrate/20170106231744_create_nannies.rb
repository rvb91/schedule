class CreateNannies < ActiveRecord::Migration[5.0]
  def change
    create_table :nannies do |t|
      t.integer :user_id

      t.timestamps
    end
  end
end
