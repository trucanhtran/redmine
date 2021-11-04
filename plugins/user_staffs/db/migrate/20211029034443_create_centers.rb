class CreateCenters < ActiveRecord::Migration[5.2]
  def change
    create_table :centers do |t|
      t.string :name
      t.integer :code_name, uniqueness: true
    end
  end
end
