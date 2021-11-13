class AddWorkReferenceToUser < ActiveRecord::Migration[5.2]

  def self.up
    add_reference :users, :work, index: true
  end

  def self.down
    remove_reference :users, :work, index: true
  end  

end
