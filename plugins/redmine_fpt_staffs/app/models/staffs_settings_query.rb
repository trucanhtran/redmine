# Redmine - project management software
# Copyright (C) 21/11/2019  TienDC5

class StaffsSettingsQuery < Query

  self.queried_class = StaffsSettings
  # self.view_permission = :view_issues

  self.available_columns = [
    # QueryColumn.new(:id, :sortable => "#{Staff.table_name}.id", :default_order => 'acs', :caption => '#', :frozen => true),
    QueryColumn.new(:user_id, :sortable => "#{StaffsSettings.table_name}.user_id"),
    # QueryColumn.new(:department_id, :sortable => "#{StaffsSettings.table_name}.department_id"),
    QueryColumn.new(:center_id, :sortable => "#{StaffsSettings.table_name}.center_id"),
    QueryColumn.new(:view, :sortable => "#{StaffsSettings.table_name}.view"),
    QueryColumn.new(:create, :sortable => "#{StaffsSettings.table_name}.create"),
    QueryColumn.new(:edit, :sortable => "#{StaffsSettings.table_name}.edit"),
    QueryColumn.new(:active_kpi, :sortable => "#{StaffsSettings.table_name}.active_kpi"),
    QueryColumn.new(:active_bug, :sortable => "#{StaffsSettings.table_name}.active_bug"),
  ]

  def staffs_settings(options={})
    order_option = [group_by_sort_order, (options[:order] || sort_clause)].flatten.reject(&:blank?)

    scope = StaffsSettings.where(statement).
      where(options[:conditions]).
      order(order_option).
      limit(options[:limit]).
      offset(options[:offset])
       # raise scope.preload(columns.map(&:name)).to_json
    # scope = scope.preload(columns.map(&:name))

    
    staffs = scope.to_a
    # raise options.to_json
  rescue ::ActiveRecord::StatementInvalid => e
    raise StatementInvalid.new(e.message)
  end

  def default_sort_criteria
    [['user_id', 'desc']]
  end

  def available_columns
    return @available_columns if @available_columns
    @available_columns = self.class.available_columns.dup
    @available_columns
  end

  def default_columns_names
    default_columns_names = self.class.available_columns.dup
    default_columns_names.collect{|s| s.name }
  end
  def base_scope
    StaffsSettings.where("1=1")
  end
  # Returns the staff count
  def staffs_settings_count
    base_scope.count
  rescue ::ActiveRecord::StatementInvalid => e
    raise StatementInvalid.new(e.message)
  end
end
