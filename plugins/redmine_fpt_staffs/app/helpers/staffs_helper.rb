require 'axlsx'
require 'activerecord-import/base'
module StaffsHelper

  include ApplicationHelper
  include Redmine::Export::PDF
  include Redmine::Export::PDF::IssuesPdfHelper
  include Redmine::Export::PDF::IssuesPdfHelper

  def check_active_tag(column_name,value)
    type_active = [ "Active KPI", "Active Bug","View","Edit","Update","Create"]
    if type_active.include?(column_name) 
      if value == '1'
        content_tag(:span, nil, :class => 'icon-only icon-checked')
      else
        content_tag(:span, nil, :class => nil)
      end
    else
      false
    end
  end

  def check_permission(rule, department_id=nil)
    return true if User.current.login=="admin"
    value = StaffsSettings.where("user_id = #{User.current.id}").pluck("`#{rule}`").first
    if value.present? 
      if !department_id.nil? 
        if value.is_a?(Array)
          return value.include?("#{department_id.to_s}")
        else
          return false
        end
      end
      return true
    end
    false
  end

  def custom_fields_options_for_select(id)
    CustomField.find_by_id(id).possible_values
  end

  def staff_options_for_select(type_name)
    StaffsItems.active.where(:type_name => type_name.to_s).collect {|t| [t.name, t.id]}
  end

  def staff_options_for_select_parent(type_name)
    StaffsItems.active.where(:type_name => type_name.to_s).collect {|t| [t.name, t.id, t.parent_id]}
  end

  def options_for_department_by_center(center_id)
    StaffsItems.active.where(:type_name => 'Department', :parent_id => center_id).order(:position).collect {|t| [t.name, t.id]}
  end

  def options_for_center
    StaffsItems.active.where(:type_name => 'Center').login_center.collect {|t| [t.name, t.id.to_s]}
  end

  def options_for_team_leader_in_department (department_id)
    if department_id .nil?
      []
    else
      Staff.active.where(:department_id => department_id, :work_id => 9).where("mail is not null").where.not(:mail => '').order(:mail).collect {|t| [t.mail.split("@")[0], t.id]}
    end
  end

  def get_id_item_first(type_name)
    StaffsItems.active.where(:type_name => type_name.to_s).pluck(:id).first
  end

  def staffs_column_content(column, item)
    value = column.value_object(item)

    if value.is_a?(Array)
      #Setting Item
      values = value.collect {|v| find_name_option_by_id(v)}.compact
      safe_join(values, ', ')
    else

      staffs_column_value(column, item, value)
    end
  end
  
  def staffs_column_value(column, item, value)
    
    case column.name

    when :location_id
      find_name_option_by_id(value)
    when :department_id
      find_name_option_by_id(value)
    when :job_position_id
      find_name_option_by_id(value)
    when :contract_id
      find_name_option_by_id(value)
    when :contact
      simple_format_without_paragraph(value)
    when :permanent_address
      simple_format_without_paragraph(value)
    when :temporary_address
      simple_format_without_paragraph(value)
    when :note
      simple_format_without_paragraph(value)
    when :work_id
      find_name_option_by_id(value)
    when :view
      find_name_option_by_id(value)
    when :center_id
      find_name_option_by_id(value)
    when :team_leader
      find_name_option_by_team_leader(value, item)
    when :start_date_company
      value.strftime("%d/%m/%Y") unless !value
    when :start_date_contract
      value.strftime("%d/%m/%Y") unless !value
    when :due_date_contract
      value.strftime("%d/%m/%Y") unless !value
    when :start_date_off
      value.strftime("%d/%m/%Y") unless !value
    when :end_date_off
      value.strftime("%d/%m/%Y") unless !value
    when :birthday
      value.strftime("%d/%m/%Y") unless !value
    when :identity_date
      value.strftime("%d/%m/%Y") unless !value
    when :created_on
      value.strftime("%d/%m/%Y %H:%M:%S")
    when :updated_on
      value.strftime("%d/%m/%Y %H:%M:%S")
    when :sex
      value ? "NAM" : "NỮ"
    when :user_id
      !item.user.name ? nil : item.user.name
    else
      staffs_format_object(value)
    end
  end

  def find_name_option_by_id(id)
    option = StaffsItems.find_by_id(id)
    option.present? ? option.name : nil
  end

  def find_name_option_by_team_leader(id, item)
    department_id = item['department_id']
    user = item['id']
    if id
      option = Staff.find_by_id(id)
      if User.current.admin || edit_TL_permissions(User.current.id, option.department_id) 
        select_tag('staff['+user.to_s+']', options_for_select(options_for_team_leader_in_department(option.department_id), option.id), :include_blank => true, :onchange => 'change_team_leader('+user.to_s+')')
      else 
        option.present? ? option.full_name : nil
      end
    else 
      if !department_id.nil? && (User.current.admin || edit_TL_permissions(User.current.id, department_id))
        select_tag('staff['+user.to_s+']', options_for_select(options_for_team_leader_in_department(department_id)), :include_blank => true, :onchange => 'change_team_leader('+user.to_s+')')
      else nil
      end
    end
  end

  def staffs_format_object(object, html=true, &block)
    if block_given?
      object = yield object
    end
    html ? h(object) : object.to_s
  end

  def render_option_department_by_center()
    s = content_tag('label', l(:label_department))
    if params[:id] || params[:copy_from] #Edit || Copy
      id = params[:id] ? params[:id] : params[:copy_from] 
      staff = Staff.find_by_id(id)
      if !staff.blank?
        s << select_tag('staff[department_id]', options_for_select(options_for_department_by_center(staff.center_id),staff.department_id), :include_blank => true, :onchange => 'change_department_by_center()')
      end
    else #New
      center_id = params[:center_id] ? params[:center_id] : get_id_item_first('Center')
      s << select_tag('staff[department_id]', options_for_select(options_for_department_by_center(center_id)), :include_blank => true, :onchange => 'change_department_by_center()')
    end
    s.html_safe
  end

  def render_option_team_leader_by_department()
    s = content_tag('label', l(:label_team_leader))
    if params[:id] || params[:copy_from] #Edit || Copy
      id = params[:id] ? params[:id] : params[:copy_from] 
      staff = Staff.find_by_id(id)
      if !staff.blank?
        department_id = params[:department_id] ? params[:department_id] : staff.department_id
        s << select_tag('staff[team_leader]', options_for_select(options_for_team_leader_in_department(department_id),staff.team_leader), :include_blank => true)
      else 
        department_id = params[:department_id] ? params[:department_id] : nil
        s << select_tag('staff[team_leader]', options_for_select(options_for_team_leader_in_department(department_id)), :include_blank => true)

      end
    else #New
      department_id = params[:department_id] ? params[:department_id] : nil
      # raise department_id.to_json
        s << select_tag('staff[team_leader]', options_for_select(options_for_team_leader_in_department(department_id)), :include_blank => true)
    end
    s.html_safe
  end

  def edit_TL_permissions(user, department_id)
    edit = StaffsSettings.where(:user_id => user).pluck("edit").first
    if edit.include? department_id.to_s
      return true
    else return false
    end
  end

  # Authorize the user for the requested action
  def staffs_settings_permissions(action)
    return true if User.current.admin?
    case action
      when 'new' 
        action = 'create'
      when 'index'
        action = 'view'
      when 'dashboard'
        action = "view"
    end

    if action != 'destroy'
      settings = StaffsSettings.where("user_id = #{User.current.id}").pluck("`#{action}`").first
    end
      
    if settings.present? && action != 'destroy'
      return true
    else
      deny_access
    end
  end

  def staffs_to_pdf(staffs, query)
    pdf = ITCPDF.new(current_language, "L")
    title = Time.now.strftime("%d/%m/%Y ") + "_Staffs"
    pdf.set_title(title)
    pdf.alias_nb_pages
    pdf.footer_date = format_date(User.current.today)
    pdf.set_auto_page_break(false)
    pdf.add_page("L")

    # Landscape A4 = 210 x 297 mm
    page_height   = pdf.get_page_height # 210
    page_width    = pdf.get_page_width  # 297
    left_margin   = pdf.get_original_margins['left'] # 10
    right_margin  = pdf.get_original_margins['right'] # 10
    bottom_margin = pdf.get_footer_margin
    row_height    = 4

    # column widths
    table_width = page_width - right_margin - left_margin
    col_width = []
    unless query.inline_columns.empty?
      col_width = calc_col_width(staffs, query, table_width, pdf)
      table_width = col_width.inject(0, :+)
    end

    # use full width if the description or last_notes are displayed
    if table_width > 0 && (query.has_column?(:description) || query.has_column?(:last_notes))
      col_width = col_width.map {|w| w * (page_width - right_margin - left_margin) / table_width}
      table_width = col_width.inject(0, :+)
    end

    # title
    pdf.SetFontStyle('B',11)
    pdf.RDMCell(190, 8, title)
    pdf.ln

    # totals
    totals = query.totals.map {|column, total| "#{column.caption}: #{total}"}
    if totals.present?
      pdf.SetFontStyle('B',10)
      pdf.RDMCell(table_width, 6, totals.join("  "), 0, 1, 'R')
    end

    totals_by_group = query.totals_by_group
    render_table_header(pdf, query, col_width, row_height, table_width)
    previous_group = false
    result_count_by_group = query.result_count_by_group

    staff_list(staffs) do |staff, level|
      if query.grouped? &&
           (group = query.group_by_column.value(staff)) != previous_group
        pdf.SetFontStyle('B',10)
        group_label = group.blank? ? 'None' : group.to_s.dup
        group_label << " (#{result_count_by_group[group]})"
        pdf.bookmark group_label, 0, -1
        pdf.RDMCell(table_width, row_height * 2, group_label, 'LR', 1, 'L')
        pdf.SetFontStyle('',8)

        totals = totals_by_group.map {|column, total| "#{column.caption}: #{total[group]}"}.join("  ")
        if totals.present?
          pdf.RDMCell(table_width, row_height, totals, 'LR', 1, 'L')
        end
        previous_group = group
      end

      # fetch row values
      col_values = fetch_row_values(staff, query)
      # raise col_values.to_json
      # make new page if it doesn't fit on the current one
      base_y     = pdf.get_y
      max_height = get_issues_to_pdf_write_cells(pdf, col_values, col_width)
      space_left = page_height - base_y - bottom_margin
      if max_height > space_left
        pdf.add_page("L")
        render_table_header(pdf, query, col_width, row_height, table_width)
        base_y = pdf.get_y
      end

      # write the cells on page
      issues_to_pdf_write_cells(pdf, col_values, col_width, max_height)
      pdf.set_y(base_y + max_height)

      if query.has_column?(:description) && staff.description?
        pdf.set_x(10)
        pdf.set_auto_page_break(true, bottom_margin)
        pdf.RDMwriteHTMLCell(0, 5, 10, '', staff.description.to_s, staff.attachments, "LRBT")
        pdf.set_auto_page_break(false)
      end

      if query.has_column?(:last_notes) && staff.last_notes.present?
        pdf.set_x(10)
        pdf.set_auto_page_break(true, bottom_margin)
        pdf.RDMwriteHTMLCell(0, 5, 10, '', staff.last_notes.to_s, [], "LRBT")
        pdf.set_auto_page_break(false)
    end
    end

    if staffs.size == Setting.issues_export_limit.to_i
      pdf.SetFontStyle('B',10)
      pdf.RDMCell(0, row_height, '...')
    end
    pdf.output
  end

  # fetch row values
  def fetch_row_values(staff, query)
    query.inline_columns.collect do |column|
      value = staff.send(column.name)
        case column.name
          when :location_id
            value = find_name_option_by_id(value)
          when :department_id
            value = find_name_option_by_id(value)
          when :contract_id
            value = find_name_option_by_id(value)
          when :work_id
            value = find_name_option_by_id(value)
          when :center_id
            value = find_name_option_by_id(value)
          when :attachments
            value = value.to_a.map {|a| a.filename}.join("\n")
          when :sex
            if value
              value = "Nam"
            else 
              value = "Nữ"
            end
          when :active_kpi
            if value == "1"
              value = "Có"
            elsif value == "0"
              value = "Không"
            end
          when :active_bug
            if value == "1"
              value = "Có"
            elsif value == "0"
              value = "Không"
            end
          when :team_leader
            if staff[:team_leader]
              value = Staff.find(staff[:team_leader]).mail.split("@")[0]
            end
          when :job_position_id
            if staff[:job_position_id] != nil
              value = StaffsItems.find(staff[:job_position_id]).name
            end
          end
          if value.is_a?(Date)
            format_date(value)
          elsif value.is_a?(Time)
            format_time(value)
          else
            value.to_s
        end
    end
  end

  # calculate columns width
  def calc_col_width(staffs, query, table_width, pdf)
    # calculate statistics
    #  by captions
    pdf.SetFontStyle('B',8)
    margins = pdf.get_margins
    col_padding = margins['cell']
    col_width_min = query.inline_columns.map {|v| pdf.get_string_width(v.caption) + col_padding}
    col_width_max = Array.new(col_width_min)
    col_width_avg = Array.new(col_width_min)
    col_min = pdf.get_string_width('OO') + col_padding * 2
    if table_width > col_min * col_width_avg.length
      table_width -= col_min * col_width_avg.length
    else
      col_min = pdf.get_string_width('O') + col_padding * 2
      if table_width > col_min * col_width_avg.length
        table_width -= col_min * col_width_avg.length
      else
        ratio = table_width / col_width_avg.inject(0, :+)
        return col_width = col_width_avg.map {|w| w * ratio}
      end
    end
    word_width_max = query.inline_columns.map {|c|
      n = 10
      c.caption.split.each {|w|
        x = pdf.get_string_width(w) + col_padding
        n = x if n < x
      }
      n
    }

    #  by properties of staffs
    pdf.SetFontStyle('',8)
    k = 1
    staff_list(staffs) {|staff, level|
      k += 1
      values = fetch_row_values(staff, query)
      values.each_with_index {|v,i|
        n = pdf.get_string_width(v) + col_padding * 2
        col_width_max[i] = n if col_width_max[i] < n
        col_width_min[i] = n if col_width_min[i] > n
        col_width_avg[i] += n
        v.split.each {|w|
          x = pdf.get_string_width(w) + col_padding
          word_width_max[i] = x if word_width_max[i] < x
        }
      }
    }
    col_width_avg.map! {|x| x / k}

    # calculate columns width
    ratio = table_width / col_width_avg.inject(0, :+)
    col_width = col_width_avg.map {|w| w * ratio}

    # correct max word width if too many columns
    ratio = table_width / word_width_max.inject(0, :+)
    word_width_max.map! {|v| v * ratio} if ratio < 1

    # correct and lock width of some columns
    done = 1
    col_fix = []
    col_width.each_with_index do |w,i|
      if w > col_width_max[i]
        col_width[i] = col_width_max[i]
        col_fix[i] = 1
        done = 0
      elsif w < word_width_max[i]
        col_width[i] = word_width_max[i]
        col_fix[i] = 1
        done = 0
      else
        col_fix[i] = 0
      end
    end

    # iterate while need to correct and lock coluns width
    while done == 0
      # calculate free & locked columns width
      done = 1
      ratio = table_width / col_width.inject(0, :+)

      # correct columns width
      col_width.each_with_index do |w,i|
        if col_fix[i] == 0
          col_width[i] = w * ratio

          # check if column width less then max word width
          if col_width[i] < word_width_max[i]
            col_width[i] = word_width_max[i]
            col_fix[i] = 1
            done = 0
          elsif col_width[i] > col_width_max[i]
            col_width[i] = col_width_max[i]
            col_fix[i] = 1
            done = 0
          end
        end
      end
    end

    ratio = table_width / col_width.inject(0, :+)
    col_width.map! {|v| v * ratio + col_min}
    col_width
  end

  def staff_list(staffs, &block)
    ancestors = []
    staffs.each do |staff|
      while (ancestors.any?)
        ancestors.pop
      end
      yield staff, ancestors.size
      ancestors << staff
    end
  end

  def staffs_to_excel(staffs, query)
    caption_row = []
    query.inline_columns.each do |column|
      caption_row << column.caption
    end
    p = Axlsx::Package.new
    p.use_autowidth = true
    wb = p.workbook
    wb.styles do |s|
      css_header = s.add_style :fg_color=> "FFFFFF",
                            :b => true,
                            :bg_color => "004586",
                            :sz => 12,
                            :border => { :style => :thin, :color => "00" },
                            :alignment => { :horizontal => :center,
                                            :vertical => :center ,
                                            :wrap_text => true}
      css_body = s.add_style :sz => 11,
                            :border => { :style => :thin, :color => "00" },
                            :alignment => { :horizontal => :left,
                                            :vertical => :center ,
                                            :wrap_text => true}
      wb.add_worksheet do |sheet|
        sheet.add_row caption_row, :style => css_header
        staffs.each do |staff|  
          values = fetch_row_values(staff, query)
          sheet.add_row values, :style => css_body
        end

      end
    end
    p
  end
  
def get_data_employee(startmonth, endmonth, year, department)
    data = []
    for i in startmonth..endmonth
      employee_in = Staff.where("(" +  "DATE_FORMAT(start_date_company,'%m-%y') = DATE_FORMAT('" + year + "-" + i.to_s + "-01" + "','%m-%y'))" + department.to_s).count()
      employee_out = Staff.where("start_date_company < '" + year + "-" + (i+1).to_s + "-01' AND " + "(" +  "DATE_FORMAT(start_date_off,'%m-%y') = DATE_FORMAT('" + year + "-" + i.to_s + "-01" + "','%m-%y') AND work_id IN (10,11,12,13,14,15,46))" + department.to_s).count()
      employee_out_from_this_month_to_before = Staff.where("start_date_company < '" + year + "-" + (i+1).to_s + "-01' AND " + "start_date_off < '" + year + "-" + (i+1).to_s + "-01' and work_id IN (10,11,12,13,14,15,46)" + department.to_s).count()
      employee = Staff.where("start_date_company < '" + year + "-" + (i+1).to_s + "-01'"  + department.to_s).count() - employee_out_from_this_month_to_before
      month = i<10? "0":"" 
      month += i.to_s + "/" + year
      data += [{:month => month,:in => employee_in, :out => employee_out, :total => employee}]
    end
    data
  end

  def dashboard_employee_overall(params)
    data = []
    if !params[:startDate].nil?
      startDate = params[:startDate].split("-")
      startYear = startDate[0].to_i
      startMonth = startDate[1].to_i
      if params[:endDate].nil?
        month_current = Date.today.strftime("%m").to_i
        year_current = Date.today.strftime("%Y").to_i
        if year_current == startYear
          month = month_current
          year = year_current
        else 
          month = 12
          year = startYear
        end
        data += get_data_employee(1, month, year.to_s, params[:department])
      else
        endDate = params[:endDate].split("-")
        endYear = endDate[0].to_i
        endMonth = endDate[1].to_i
        if startYear < endYear
          for i in startYear..endYear
            if i == startYear
              data += get_data_employee(startMonth, 12, i.to_s, params[:department])
            elsif i == endYear
              data += get_data_employee(1, endMonth, i.to_s, params[:department])
            else
              data += get_data_employee(1, 12, i.to_s, params[:department])
            end
          end
        else 
          data += get_data_employee(startMonth, endMonth, startYear.to_s, params[:department])
        end
      end
    else 
      data = [{:month => "", :in => nil, :out => nil, :total => nil}]
    end
    data
  end

  def dashboard_employee_info(params, column, color = '')
    data = []
    sqlcondition = "(1 = 1)"
    if !params[:startDate].nil? && params[:endDate].nil?
      startDate = params[:startDate].split("-")
      year = startDate[0].to_i
      month = startDate[1].to_i
      condition_start_date_company = " AND start_date_company < '" + year.to_s+ "-" + (month+1).to_s + "-01'"
      names = "THÁNG " + params[:startDate].split("-")[1] + "-" + params[:startDate].split("-")[0]
      sqlcondition += " AND (DATE_FORMAT(staffs." + column + ",'%Y-%m') = '#{params[:startDate]}')"
    elsif !params[:startDate].nil? && !params[:endDate].nil?
      endDate = params[:endDate].split("-")
      year = endDate[0].to_i
      month = endDate[1].to_i
      condition_start_date_company = "AND start_date_company < '" + year.to_s + "-" + (month+1).to_s + "-01'"
      names = "TỪ " + params[:startDate].split("-")[1] + "-" + params[:startDate].split("-")[0] + " ĐẾN " + params[:endDate].split("-")[1] + "-" + params[:endDate].split("-")[0]
      sqlcondition += " AND (DATE_FORMAT(staffs." + column + ",'%Y-%m') BETWEEN '#{params[:startDate]}' and '#{params[:endDate]}')"
    end
    if !params[:startDate].nil?
      if column == "start_date_off" and color == "reason_off"
        employee = Staff.joins("JOIN staffs_items on staffs.work_id = staffs_items.id").where(sqlcondition + condition_start_date_company).where("work_id IN (10,11,12,13,14,15,46)"  + params[:department].to_s).group("staffs_items.name").select("staffs_items.id, staffs_items.name, count(*) as number")
        list_reason = {10=>0, 11=>0, 12=>0, 13=>0, 14=>0, 15=>0, 46=>0}
        employee.each do |i|
          list_reason[i.id] = i.number
        end
        data = [['Nghỉ tạm - thai sản', list_reason[10]],
               ['Nghỉ tạm - không lương', list_reason[11]], 
               ['Nghỉ việc - gia đình', list_reason[12]], 
               ['Nghỉ việc - vì học tiếp', list_reason[13]], 
               ['Nghỉ việc - định hướng mới', list_reason[14]], 
               ['Nghỉ việc - do thanh lý', list_reason[15]],
               ['Nghỉ việc - lương không cạnh tranh', list_reason[46]]]
      else 
        if column == 'start_date_off'
          employee = Staff.where(sqlcondition+condition_start_date_company).where("work_id IN (10,11,12,13,14,15,46)"  + params[:department].to_s).group(:job_code).select("job_code, count(*) as number")
        elsif column == 'start_date_company'
         employee = Staff.where(sqlcondition + condition_start_date_company + params[:department].to_s).group(:job_code).select("job_code, count(*) as number")
        end
        if employee
          employee.each do |i|
            if i["job_code"] != ""
              data += [{name: (i["job_code"].nil? or i["job_code"]=="") ? "Khác":i["job_code"], y: i["number"], color: color}]
            else
              count = 0
              data.each do |x|
                if x[:name] == "Khác"
                  x[:y] += i["number"]
                  break
                end
                count += 1
              end
              if count == data.count
                data += [{name: "Khác", y: i["number"], color: color}]
              end
            end
          end
        end
      end
    end
    [data, names]
  end

  def dashboard_employee_year(params)
    data = []
    if !params[:half_year].nil?
      if params[:half_year].count == 1
        tmp_name = params[:half_year][0].to_s + "H"
        if params[:half_year][0].to_i == 1
          date = ["-01-01", "-06-30"]
        else date = ["-07-01", "-12-31"]
        end
      else 
        tmp_name = ''
        date = ["-01-01", "-12-31"]
      end
      if !params[:startYear].nil? && !params[:endYear].nil?
        for i in params[:startYear].to_i..params[:endYear].to_i
          employee_in = Staff.where("start_date_company BETWEEN '" + i.to_s + date[0] + "'" + " and '" + i.to_s + date[1] + "'" + params[:department].to_s).count()
          employee_out = Staff.where("start_date_company <= '" + i.to_s + date[1] + "' and " + "start_date_off BETWEEN '" + i.to_s + date[0] + "'" + " and '" + i.to_s + date[1] + "' AND work_id IN (10,11,12,13,14,15,46)" + params[:department].to_s).count()
          employee_out_from_this_month_to_before = Staff.where("start_date_company <= '" + i.to_s + date[1] + "' and " + "start_date_off <= '" + i.to_s + date[1] + "' and work_id IN (10,11,12,13,14,15,46)" + params[:department].to_s).count()
          employee = Staff.where("start_date_company <= '" + i.to_s + date[1] + "'" + params[:department].to_s).count() - employee_out_from_this_month_to_before
          month = tmp_name + i.to_s
          data += [{:month => month,:in => employee_in, :out => employee_out, :total => employee}]
        end
      end  
    end
    data
  end

  def dashboard_reason_off_year(params)
    data = []
    color = ["#D6298A", "#FFDB00", "#A733CB", "#ffcc99", "#a9d08e", "#4472c4"]
    if !params[:startYear].nil? && !params[:endYear].nil?
      for i in params[:startYear].to_i..params[:endYear].to_i
        list_reason = {10=>0, 11=>0, 12=>0, 13=>0, 14=>0, 15=>0, 46=>0}
        sqlcondition = "(DATE_FORMAT(staffs.start_date_off ,'%Y') = '#{i}')"
        employee = Staff.joins("JOIN staffs_items on staffs.work_id = staffs_items.id").where("start_date_company <= '" + i.to_s + "12-31' AND " + sqlcondition + params[:department].to_s).where("work_id IN (10,11,12,13,14,15,46)").group("staffs_items.name").select("staffs_items.id, staffs_items.name, count(*) as number")
        employee.each do |i|
          list_reason[i.id] = i.number
        end
        data += [{:name => i, :data => list_reason.values, color: color[i%6]}]
      end
    end
    data
  end

  def get_auto_identity_card
    max_identity_card = Staff.select(:identity_card).
                        order("identity_card desc").limit(1).collect {|g| [g.identity_card.to_i] }
    return max_identity_card[0][0] + 1
  end
end
