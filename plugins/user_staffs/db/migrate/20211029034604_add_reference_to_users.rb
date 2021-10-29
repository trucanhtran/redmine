class AddReferenceToUsers < ActiveRecord::Migration[5.2]

  def self.up
    add_reference :users, :centers, index: true
  end

  def self.down
    remove_reference :users, :centers, index: true
  end  
  
end
