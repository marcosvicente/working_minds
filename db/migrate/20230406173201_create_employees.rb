class CreateEmployees < ActiveRecord::Migration[7.0]
  def change
    create_table :employees do |t|
      t.string :name, null: false
      t.string :role, null: false
      t.date :date_contract, null: false

      t.timestamps
    end
  end
end
