class AddReferenceCenterToUser < ActiveRecord::Migration[5.2]

  def self.up
    add_reference :users, :center, index: true
  end

  def self.down
    remove_reference :users, :center, index: true
  end  
  
end
