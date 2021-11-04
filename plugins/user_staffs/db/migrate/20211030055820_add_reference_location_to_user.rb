class AddReferenceLocationToUser < ActiveRecord::Migration[5.2]
  def self.up
    add_reference :users, :location, index: true
  end

  def self.down
    remove_reference :users, :location, index: true
  end  
end
