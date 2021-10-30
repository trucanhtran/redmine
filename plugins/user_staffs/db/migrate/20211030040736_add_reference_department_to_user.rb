class AddReferenceDepartmentToUser < ActiveRecord::Migration[5.2]
  def self.up
    add_reference :users, :department, index: true
  end

  def self.down
    remove_reference :users, :department, index: true
  end  
end
