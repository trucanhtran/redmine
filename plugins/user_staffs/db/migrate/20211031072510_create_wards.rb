class CreateWards < ActiveRecord::Migration[5.2]
  def change
    create_table :wards do |t|
      t.string :name
      t.integer :code, uniqueness: true
      t.string :code_name
      t.integer :phone_code
      t.belongs_to :district
    end
  end
end
