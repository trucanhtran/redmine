class CreateDistricts < ActiveRecord::Migration[5.2]
  def change
    create_table :districts do |t|
      t.string :name
      t.integer :code, uniqueness: true
      t.string :code_name
      t.integer :phone_code
    end
  end
end
