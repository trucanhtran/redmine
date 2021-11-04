class CreateProvinces < ActiveRecord::Migration[5.2]
  def change
    create_table :provinces do |t|
      t.string :name
      t.integer :code, uniqueness: true
      t.string :code_name
      t.integer :phone_code
    end
  end
end
