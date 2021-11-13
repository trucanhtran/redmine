class CreateMicroposts < ActiveRecord::Migration[5.2]
  def change
    create_table :microposts do |t|
      t.string :picture
      t.belongs_to :user
    end
  end
end
