class AddUserWhiteListToCategories < ActiveRecord::Migration[5.2]
  def change
      add_column :kb_categories, :user_whitelist, :string,:default =>
      ""
      
  end
end
