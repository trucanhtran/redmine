class CreateStaffs < ActiveRecord::Migration[5.2]
  def up
    create_table :staffs, :force => true do |t|
      t.integer :user_id
    	t.string :employee_id, :limit => 8
    	t.string :full_name, :limit => 100, :null => false
    	t.string :mail, :limit => 50
    	t.string :another_email, :limit => 50
      t.integer :team_leader
      t.integer :type_staff
      t.string :hardskill, :limit => 255
      t.string :softskill, :limit => 255
      t.string :achievement, :limit => 255
    	t.date :start_date_company
    	t.date :start_date_contract
      t.date :due_date_contract
      t.date :start_date_off
      t.date :end_date_off
    	t.boolean :sex, :default => true, :null => false
    	t.date :birthday
    	t.string :place_birth, :limit => 50
    	t.string :phone
    	t.string :permanent_address, :limit => 255
    	t.string :temporary_address, :limit => 255
    	t.string :identity_card, :null => false
    	t.date :identity_date
    	t.string :identity_by, :limit => 50
    	t.string :ethnic, :limit => 50
    	t.string :contact, :limit => 255
    	t.string :note, :limit => 255
      t.string :active_kpi, :limit => 1
      t.string :active_bug, :limit => 1
      t.integer :location_id
      t.integer :department_id
      t.integer :position_id
      t.integer :job_title_id
      t.integer :job_position_id
      t.integer :contract_id
      t.integer :status, :default => 1
      t.integer :work_id
      t.integer :center_id
      t.string :job_code
      t.string :job_code_tmp
      t.text :certificate
      t.integer :degree_id
      t.string :staff_avatar
      t.string :updated_by
      t.timestamp :created_on
      t.timestamp :updated_on
    end
    add_index "staffs", ["user_id"], :name => "staffs_user_id"
    add_index "staffs", ["location_id"], :name => "staffs_location_id"
    add_index "staffs", ["department_id"], :name => "staffs_department_id"
    add_index "staffs", ["position_id"], :name => "staffs_position_id"
    add_index "staffs", ["contract_id"], :name => "staffs_contract_id"
    add_index "staffs", ["work_id"], :name => "staffs_work_id"
    add_index "staffs", ["center_id"], :name => "staffs_center_id"
    add_index "staffs", ["job_position_id"], :name => "staffs_job_position_id"
    add_index "staffs", ["job_title_id"], :name => "staffs_job_title_id"
  end
  def down
    drop_table :staffs
  end
end
