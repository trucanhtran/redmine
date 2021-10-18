# Redmine - project management software
# Copyright (C) 21/11/2019  TienDC5

class StaffDashboardQuery < Query

    self.queried_class = Staff
      
    def initialize(attributes=nil, *args)
      super attributes
      self.filters ||= { 'month' => {:operator => "=", :values => [Date.today.to_s] },
                         'year' => {:operator => "><", :values => [Date.today.to_s] },
                          'half_year' => {:values => ["1"] }}
    end
    
    def initialize_available_filters
      add_available_filter "month", :type => :date_past, :name => "Time (yyyy-mm)"
      add_available_filter "year", :type => :date_past, :name => "Year"
      add_available_filter "half_year",
      :type => :list, :values => [["1H", "1"], ["2H", "2"]], :name => "Haft-year"
      add_available_filter "department", :type => :list_optional, 
      :values => lambda { get_drop_list_department.collect {|g| [g.name, g.id] } }, :name => "Department"
    end

    def get_drop_list_department
      a =  StaffsItems.select("id, name").where("type_name = 'Department' AND status = 1").distinct
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
                  if field == "month"
                    month << v + "-01"
                  elsif field == "year"
                    month << v + "-01-01"
                  end
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
  
    def staffs(options={})
      order_option = [group_by_sort_order, (options[:order] || sort_clause)].flatten.reject(&:blank?)
      # raise statement.to_json
      scope = Staff.
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
  
    def params_statement(options = {})
      params = {:startDate => nil,
        :endDate => nil,
        :startYear => nil,
        :endYear => nil,
        :half_year => nil,
        :department => nil}
        filters.each_key do |field|
          if !values_for(field).nil?
            v = values_for(field).clone
          else v = nil
          end
          operator = operator_for(field)
          case field
          when "month"
            if operator == "><"
              if !v.first.empty? and !v.last.empty?
                if v.first > v.last
                  errors.add :base, I18n.t(:error_starttime_must_smaller_than_endtime)
                end
              end
              if !v.first.empty?
  
                params[:startDate] = Time.parse(v.first).strftime('%Y-%m')
              end
              if !v.last.empty?
                  params[:endDate] = Time.parse(v.last).strftime('%Y-%m')
              end
            elsif operator == "="
              params[:startDate] = Time.parse(v.first).strftime('%Y-%m')
            else params[:startDate] = Time.parse(DateTime.now.strftime("%Y-%m-%d")).strftime('%Y-%m')
            end
          when "year"
            if operator == "><"
              if !v.first.empty? and !v.last.empty?
                if v.first > v.last
                  errors.add :base, I18n.t(:error_startyear_must_smaller_than_endyear)
                end
              end
              if v.size > 1
                if !v.first.empty?
                  params[:startYear] = Time.parse(v.first).strftime('%Y')
                end
                if !v.last.empty?
                    params[:endYear] = Time.parse(v.last).strftime('%Y')
                end
              else 
                if !v.first.empty?
                  params[:endYear] = Time.parse(v.first).strftime('%Y')
                  params[:startYear] = (params[:endYear].to_i - 1).to_s
                end
              end
            else 
              now = DateTime.now
              params[:startYear] = (now.year - 1).to_s
              params[:endYear] = now.year.to_s
            end
          when "half_year"
            if operator == "="
              params[:half_year] = v
            else
              if !v.nil?
                params[:half_year] = v
              end
            end
          when "department"
            params[:department] = query_department(operator, v)
          end 
        end if filters
      # raise params.to_s
      params
    end

    def query_department(operator, v)
      case operator
      when "="
        query = " AND staffs.department_id in (" + v.join(', ') + ")"
      when "!"
        query = " AND staffs.department_id not in (" + v.join(', ') + ")"
      when "!*"
        query = " AND staffs.department_id is null"
      when "*"
        query = ""
      end
      query
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
      note)"
    end
  end
  