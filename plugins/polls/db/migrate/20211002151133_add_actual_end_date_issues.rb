class AddActualEndDateIssues < ActiveRecord::Migration[4.2]
  def self.up
    add_column :issues, :actual_end_date_issue, :timestamp
  end

  def self.down
    remove_column :issues, :actual_end_date_issue
  end
end


