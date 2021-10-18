class CreateStaffsSettings < ActiveRecord::Migration[5.2]
  def up
    create_table :staffs_settings do |t|
        t.references :user, foreign_key: true
    		t.integer :user_id
        t.integer :department_id
	    	t.integer :center_id
	    	t.text :view
	    	t.text :edit
	    	t.text :create
	    	t.text :active_kpi
	    	t.text :active_bug
	    	t.timestamp :created_on
      	t.timestamp :updated_on
      	t.string :updated_by
    end
    add_index "staffs_settings", ["user_id"], :name => "staffs_settings_user_id"
    add_index "staffs_settings", ["center_id"], :name => "staffs_settings_center_id"
    add_index "staffs_settings", ["department_id"], :name => "staffs_settings_department_id"
  end
  def down
    drop_table :staffs_settings
  end
end
