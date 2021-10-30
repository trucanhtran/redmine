class AddReferenceProvinceToUser < ActiveRecord::Migration[5.2]
  def self.up
    add_reference :locations, :province, index: true
  end

  def self.down
    remove_reference :locations, :province, index: true
  end  
end
