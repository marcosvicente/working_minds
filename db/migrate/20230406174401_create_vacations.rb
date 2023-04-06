class CreateVacations < ActiveRecord::Migration[7.0]
  def change
    create_table :vacations do |t|
      t.references :employee, null: false, foreign_key: true
      t.date :date_init, null: false
      t.date :date_end, null: false

      t.timestamps
    end
  end
end
