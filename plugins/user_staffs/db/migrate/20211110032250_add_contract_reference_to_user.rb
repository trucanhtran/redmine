class AddContractReferenceToUser < ActiveRecord::Migration[5.2]

    def self.up
      add_reference :users, :contract, index: true
    end
  
    def self.down
      remove_reference :users, :contract, index: true
    end  
 
end
