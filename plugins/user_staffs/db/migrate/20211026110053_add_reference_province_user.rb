class AddReferenceProvinceUser < ActiveRecord::Migration[5.2]

  def self.up
    add_reference :users, :province, index: true
  end

  def self.down
    remove_reference :users, :province, index: true
  end  
  
end
