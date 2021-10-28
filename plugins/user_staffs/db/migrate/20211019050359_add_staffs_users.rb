class AddStaffsUsers < ActiveRecord::Migration[4.2]
  def self.up
    add_column :users, :another_email, :string
    add_column :users, :phone, :float
    add_column :users, :birthday, :datetime
    add_column :users, :sex, :boolean
    add_column :users, :active_kpi, :boolean
    add_column :users, :active_bug, :boolean
    add_column :users, :address, :string
    add_column :users, :location, :string
    add_column :users, :department, :string
    add_column :users, :type_staffs, :string
    add_column :users, :position, :string
    add_column :users, :team_leader, :string
    
  end

  def self.down
    remove_column :users, :another_email, :string
    remove_column :users, :phone, :float
    remove_column :users, :birthday, :datetime
    remove_column :users, :sex, :boolean
    remove_column :users, :active_kpi, :boolean
    remove_column :users, :active_bug, :boolean
    remove_column :users, :address, :string
    remove_column :users, :location, :string
    remove_column :users, :department, :string
    remove_column :users, :type_staffs, :string
    remove_column :users, :position, :string
    remove_column :users, :team_leader, :string
  end
end


