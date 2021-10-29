class AddReferenceDepartmentToUsers < ActiveRecord::Migration[5.2]
  def self.up
    add_reference :users, :departments, index: true
  end

  def self.down
    remove_reference :users, :departments, index: true
  end  
end
