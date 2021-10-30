class AddReferenceJobPositionToUser < ActiveRecord::Migration[5.2]
  def self.up
    add_reference :users, :job_position, index: true
  end

  def self.down
    remove_reference :users, :job_position, index: true
  end  
end
