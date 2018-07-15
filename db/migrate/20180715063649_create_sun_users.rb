class CreateSunUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :sun_users do |t|
      t.string :line_id, null: false

      t.timestamps
    end
  end
end
