class AddStaffsUsers < ActiveRecord::Migration[4.2]
  def self.up
    add_column :users, :another_email, :string
    add_column :users, :phone, :float
    add_column :users, :birthday, :datetime
    add_column :users, :sex, :boolean
    add_column :users, :active_kpi, :boolean
    add_column :users, :active_bug, :boolean
    add_column :users, :team_leader, :int
    add_column :users, :type_staff, :int
    add_column :users, :hardskill, :string
    add_column :users, :softskill, :string
    add_column :users, :achievement, :string
    add_column :users, :start_date_company, :datetime
    add_column :users, :start_date_contract, :datetime
    add_column :users, :due_date_contract, :datetime
    add_column :users, :start_date_off, :datetime
    add_column :users, :end_date_off, :datetime
    add_column :users, :place_birth, :string
    add_column :users, :permanent_address, :string
    add_column :users, :temporary_address, :string
    add_column :users, :identity_card, :string
    add_column :users, :identity_date, :datetime
    add_column :users, :identity_by, :string
    add_column :users, :ethnic, :string
    add_column :users, :contact, :string
    add_column :users, :note, :string
  end

  def self.down
    remove_column :users, :another_email, :string
    remove_column :users, :phone, :float
    remove_column :users, :birthday, :datetime
    remove_column :users, :sex, :boolean
    remove_column :users, :active_kpi, :boolean
    remove_column :users, :active_bug, :boolean
    remove_column :users, :team_leader, :int
    remove_column :users, :type_staff, :int
    remove_column :users, :hardskill, :string
    remove_column :users, :softskill, :string
    remove_column :users, :achievement, :string
    remove_column :users, :start_date_company, :datetime
    remove_column :users, :start_date_contract, :datetime
    remove_column :users, :due_date_contract, :datetime
    remove_column :users, :start_date_off, :datetime
    remove_column :users, :end_date_off, :datetime
    remove_column :users, :place_birth, :string
    remove_column :users, :permanent_address, :string
    remove_column :users, :temporary_address, :string
    remove_column :users, :identity_card, :string
    remove_column :users, :identity_date, :datetime
    remove_column :users, :identity_by, :string
    remove_column :users, :ethnic, :string
    remove_column :users, :contact, :string
    remove_column :users, :note, :string
  end
end


