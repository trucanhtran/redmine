# Redmine - project management software
# Copyright (C) 21/11/2019  TienDC5

class StaffQuery < Query

  self.queried_class = Staff
  # self.view_permission = :view_issues

  self.available_columns = [
    # QueryColumn.new(:id, :sortable => "#{Staff.table_name}.id", :default_order => 'acs', :caption => '#', :frozen => true),
    QueryColumn.new(:employee_id, :sortable => "#{Staff.table_name}.employee_id"),
    QueryColumn.new(:full_name, :sortable => "#{Staff.table_name}.full_name"),
    QueryColumn.new(:mail, :sortable => "#{Staff.table_name}.mail"),
    QueryColumn.new(:another_email, :sortable => "#{Staff.table_name}.another_email"),
    QueryColumn.new(:active_kpi, :sortable => "#{Staff.table_name}.active_kpi"),
    QueryColumn.new(:active_bug, :sortable => "#{Staff.table_name}.active_bug"),
    QueryColumn.new(:location_id, :sortable => "#{Staff.table_name}.location_id"),
    QueryColumn.new(:center_id, :sortable => "#{Staff.table_name}.center_id"),
    QueryColumn.new(:department_id, :sortable => "#{Staff.table_name}.department_id"),
    QueryColumn.new(:team_leader, :sortable => "#{Staff.table_name}.team_leader"),
    QueryColumn.new(:job_position_id, :sortable => "#{Staff.table_name}.job_position_id"),
    QueryColumn.new(:contract_id, :sortable => "#{Staff.table_name}.contract_id"),
    QueryColumn.new(:work_id, :sortable => "#{Staff.table_name}.work_id"),
    QueryColumn.new(:job_code, :sortable => "#{Staff.table_name}.job_code"),
    QueryColumn.new(:job_code_tmp, :sortable => "#{Staff.table_name}.job_code_tmp"),
    QueryColumn.new(:start_date_company, :sortable => "#{Staff.table_name}.start_date_company"),
    QueryColumn.new(:start_date_contract, :sortable => "#{Staff.table_name}.start_date_contract"),
    QueryColumn.new(:due_date_contract, :sortable => "#{Staff.table_name}.due_date_contract"),
    QueryColumn.new(:sex, :sortable => "#{Staff.table_name}.sex"),
    QueryColumn.new(:birthday, :sortable => "#{Staff.table_name}.birthday"),
    QueryColumn.new(:place_birth, :sortable => "#{Staff.table_name}.place_birth"),
    QueryColumn.new(:phone, :sortable => "#{Staff.table_name}.phone"),
    QueryColumn.new(:permanent_address, :sortable => "#{Staff.table_name}.permanent_address"),
    QueryColumn.new(:temporary_address, :sortable => "#{Staff.table_name}.temporary_address"),
    QueryColumn.new(:identity_card, :sortable => "#{Staff.table_name}.identity_card"),
    QueryColumn.new(:identity_date, :sortable => "#{Staff.table_name}.identity_date"),
    QueryColumn.new(:identity_by, :sortable => "#{Staff.table_name}.identity_by"),
    QueryColumn.new(:ethnic, :sortable => "#{Staff.table_name}.ethnic"),
    QueryColumn.new(:contact, :sortable => "#{Staff.table_name}.contact"),
    QueryColumn.new(:note, :sortable => "#{Staff.table_name}.note"),
    QueryColumn.new(:created_on, :sortable => "#{Staff.table_name}.created_on", :default_order => 'desc'),
    QueryColumn.new(:updated_on, :sortable => "#{Staff.table_name}.updated_on", :default_order => 'desc'),
  ]
    
  def initialize(attributes=nil, *args)
    super attributes
    self.filters ||= { 'identity_by' => {:operator => "*", :values => [] } }
  end

  def default_sort_criteria
     [['updated_on', 'desc']]
  end

  def validate_query_filters
    filters.each_key do |field|
      if values_for (field)
        case type_for(field)
        when :integer
          add_filter_error(field, :invalid) if values_for(field).detect {|v| v.present? && !v.match(/\A[+-]?\d+(,[+-]?\d+)*\z/) }
        when :float
          add_filter_error(field, :invalid) if values_for(field).detect {|v| v.present? && !v.match(/\A[+-]?\d+(\.\d*)?\z/) }
        when :date, :date_past
          case operator_for(field)
          when "=", ">=", "<=", "><"
            month = []
            filters[field][:values].each do |v|
              if v.present? && (!v.match(/\A\d{4}-\d{2}-\d{2}(T\d{2}((:)?\d{2}){0,2}(Z|\d{2}:?\d{2})?)?\z/) || parse_date(v).nil?)
                 month << v.prepend("2000-")
              end
            end
            if !month.empty?
              filters[field][:values] = month
            end
            add_filter_error(field, :invalid) if values_for(field).detect {|v|
              v.present? && (!v.match(/\A\d{4}-\d{2}-\d{2}(T\d{2}((:)?\d{2}){0,2}(Z|\d{2}:?\d{2})?)?\z/) || parse_date(v).nil?)
            }
          when ">t-", "<t-", "t-", ">t+", "<t+", "t+", "><t+", "><t-"
            add_filter_error(field, :invalid) if values_for(field).detect {|v| v.present? && !v.match(/^\d+$/) }
          end
        end
      end
      add_filter_error(field, :blank) unless
          # filter requires one or more values
          (values_for(field) and !values_for(field).first.blank?) or
          # filter doesn't require any value
          ["o", "c", "!*", "*", "t", "ld", "w", "lw", "l2w", "m", "lm", "y", "*o", "!o"].include? operator_for(field)
    end if filters
  end
  
  def initialize_available_filters

    add_available_filter "employee_id", :type => :text
    add_available_filter "full_name", :type => :text
    add_available_filter "mail", :type => :text
    add_available_filter "another_email", :type => :text
    add_available_filter "start_date_company", :type => :date_past
    add_available_filter "start_date_contract", :type => :date_past, :name => "HĐ Từ"
    add_available_filter "due_date_contract", :type => :date_past, :name => "HĐ Đến"
    add_available_filter "start_date_off", :type => :date_past, :name => "Nghỉ từ"
    add_available_filter "end_date_off", :type => :date_past, :name => "Nghỉ đến"
    add_available_filter "phone", :type => :integer
    add_available_filter "permanent_address", :type => :text
    add_available_filter "temporary_address", :type => :text
    add_available_filter "identity_card", :type => :text
    add_available_filter "identity_date", :type => :date_past
    add_available_filter "ethnic", :type => :text
    add_available_filter "contact", :type => :text
    add_available_filter "note", :type => :text
    add_available_filter "created_on", :type => :date_past
    add_available_filter "updated_on", :type => :date_past
    add_available_filter("team_leader",
      :type => :list_optional, :values => lambda { get_drop_list_leader(:mail).collect {|g| [g.name.split("@")[0], g.id.to_s] } }
    )

    add_available_filter("identity_by",
      :type => :list_optional, :values => lambda { get_drop_list(:identity_by).collect {|g| [g.name, g.name] } }
    )
    add_available_filter("sex",
      :type => :list, :values => [[l(:general_text_boy), "1"], [l(:general_text_girl), "0"]]
    )
    add_available_filter "birthday", :type => :date_past
    
    add_available_filter("place_birth",
      :type => :list_optional, :values => lambda { get_drop_list(:place_birth).collect {|g| [g.name, g.name] } }
    )
    add_available_filter("location_id",
      :type => :list_optional, :values => lambda { get_drop_list_setting(:location_id).collect {|g| [g.name, g.id.to_s] } }
    )
    add_available_filter("department_id",
      :type => :list_optional, :values => lambda { get_drop_list_setting(:department_id).collect {|g| [g.name, g.id.to_s] } }
    )
    add_available_filter("job_position_id",
      :type => :list_optional, :values => lambda { get_drop_list_setting(:job_position_id).collect {|g| [g.name, g.id.to_s] } }
    )
    add_available_filter("contract_id",
      :type => :list_optional, :values => lambda { get_drop_list_setting(:contract_id).collect {|g| [g.name, g.id.to_s] } }
    )
    add_available_filter("work_id",
      :type => :list_optional, :values => lambda { get_drop_list_setting(:work_id).collect {|g| [g.name, g.id.to_s] } }
    )
    add_available_filter("center_id",
      :type => :list_optional, :values => lambda { get_drop_list_setting(:center_id).collect {|g| [g.name, g.id.to_s] } }
    )
    add_available_filter "active_kpi",
      :type => :list, :values => [[l(:general_text_yes), "1"], [l(:general_text_no), "0"]]
    add_available_filter "active_bug",
      :type => :list, :values => [[l(:general_text_yes), "1"], [l(:general_text_no), "0"]]
    # add_available_filter "job_code",
    #   :type => :list, :values => [["DEV01", "1"], ["DEV02", "0"]]
    add_available_filter("job_code",
      :type => :list_optional, :values => get_drop_list_jobcode(:possible_values, "Job Code")
    )
    
  end

  def get_drop_list_jobcode(column, name)
    a =  CustomField.select("#{column}").where("#{column} is not null AND name = \"#{name}\" ").as_json
    list = []
    a[0]["possible_values"].each do |i|
      list.push([i,i])
    end
    list
  end

  def get_drop_list_leader(column)
    if User.current.admin
      view_by_department = ""
    else
      view = StaffsSettings.where(:user_id => User.current.id).pluck("view").first
      if !view.nil? && view.size > 0
        view_by_department = " AND department_id in ("
        view.each do |x|
          view_by_department += x + ","
        end
        if view_by_department[-1] == ","
          view_by_department[-1] = ")" 
        else view_by_department = ""
        end
      end
    end
    a =  Staff.select("#{column} as name, id").where("id in (select DISTINCT team_leader from staffs where team_leader is not null and team_leader != '' and mail is not null "+view_by_department+")").order(:mail).distinct
  end

  def get_drop_list(column)
    a =  Staff.select("#{column} as name").where("#{column} is not null AND #{column} != '' ").distinct

    # raise a.to_json
  end

  def get_drop_list_setting(column)
    Staff.select("#{column} as id, ST.name as name").joins("JOIN #{StaffsItems.table_name} ST ON staffs.#{column} = ST.id").where("#{column} is not null AND #{column} != '' ").order("ST.position ASC").distinct
  end

  def available_columns
    return @available_columns if @available_columns
    @available_columns = self.class.available_columns.dup
    @available_columns
  end

  def staffs(options={})
    order_option = [group_by_sort_order, (options[:order] || sort_clause)].flatten.reject(&:blank?)

    scope = Staff.where(statement).
      where(query).
      where(options[:conditions]).
      order(order_option).
      limit(options[:limit]).
      offset(options[:offset])
    
    staffs = scope.to_a
    # raise options[:conditions].nil?.to_json
  rescue ::ActiveRecord::StatementInvalid => e
    raise StatementInvalid.new(e.message)
  end

  def query
    if User.current.admin?
      statement = '1=1'
    else
      settings = StaffsSettings.where(:user_id => User.current.id).first
      if settings.present?
        department_ids = settings.view.to_s.gsub("[", "(").gsub("]", ")")
        return '1=0' if department_ids.empty?
        statement = "department_id IN #{department_ids}"
      else
        statement = '1=0'
      end
    end
  end

  def default_columns_names
    default_columns_names = self.class.available_columns.dup
    default_columns_names.collect{|s| s.name }
  end
  def base_scope
    Staff.active.where(statement).where(query)
  end
  # Returns the staff count
  def staff_count
    base_scope.count
  rescue ::ActiveRecord::StatementInvalid => e
    raise StatementInvalid.new(e.message)
  end
  def select_col
  "(employee_id,
    full_name,
    mail,
    another_email,
    active_kpi,
    active_bug,
    location_id,
    department_id,
    contract_id,
    work_id,
    center_id,
    job_code,
    start_date_company,
    start_date_contract,
    due_date_contract,
    sex,
    birthday,
    place_birth,
    phone,
    permanent_address,
    temporary_address,
    identity_card,
    identity_date, 
    identity_by,
    ethnic,
    contact,
    created_on,
    updated_on,
    note,
    team_leader)"
  end
end
