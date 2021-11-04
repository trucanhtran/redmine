class AddReferenceDistrictToProvince < ActiveRecord::Migration[5.2]
  def self.up
    add_reference :districts, :province, index: true
  end

  def self.down
    remove_reference :districts, :province, index: true
  end  
end
