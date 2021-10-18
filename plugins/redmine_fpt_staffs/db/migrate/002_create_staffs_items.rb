class CreateStaffsItems < ActiveRecord::Migration[5.2]
  def up
    create_table :staffs_items, :force => true do |t|
      t.integer :parent_id
      t.integer :position
    	t.string :name
    	t.string :type_name
    	t.integer :status, :default => 1
    end
  end
  def down
    drop_table :staffs_items
  end
end
