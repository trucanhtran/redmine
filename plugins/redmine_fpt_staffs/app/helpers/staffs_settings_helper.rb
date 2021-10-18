module StaffsSettingsHelper

	include ApplicationHelper

	def render_principals_for_new_staffs_settings(limit=100)
    center_id = params[:center_id] ? params[:center_id] : staff_options_for_select('Center').first[1]
    scope = Principal.active.visible.sorted
      .joins("INNER JOIN #{Staff.table_name} ON #{Staff.table_name}.user_id = #{Principal.table_name}.id")
      .where("
        #{Principal.table_name}.id NOT IN (SELECT DISTINCT user_id FROM #{StaffsSettings.table_name})
        AND #{Staff.table_name}.center_id = #{center_id.to_i}
      ")
      .like(params[:q])

    principal_count = scope.count
    principal_pages = Redmine::Pagination::Paginator.new principal_count, limit, params['page']
    principals = scope.offset(principal_pages.offset).limit(principal_pages.per_page).to_a

    s = content_tag('div',
      content_tag('div', principals_check_box_tags('staffs_settings[user_ids][]', principals), :id => 'principals'),
      :class => 'objects-selection'
    )

    links = pagination_links_full(principal_pages, principal_count, :per_page_links => false)

    s + content_tag('span', links, :class => 'pagination')
  end

  def render_department_for_change_center(staffs_settings=nil,center_id=nil)
    render_principals_for_new_staffs_settings()
    type_name =  params[:type_name] ? params[:type_name] : 'Department'
    center_id = params[:center_id] ? params[:center_id] : center_id
    departments = StaffsItems.where(:type_name => type_name, :parent_id => center_id, :status => 1).to_a
    s = ''
    if staffs_settings.nil? #New
      departments.each do |department|
        s << "
        <tr>
          <td>#{ toggle_checkboxes_link("input.department_#{department.id}")}#{  department.name}</td>
          <td>#{ check_box_tag 'staffs_settings[view][]',       department.id, false, :id => nil, :class => "view department_#{department.id}  "}</td>
          <td>#{ check_box_tag 'staffs_settings[create][]',     department.id, false, :id => nil, :class => "create department_#{department.id}"}</td>
          <td>#{ check_box_tag 'staffs_settings[edit][]',       department.id, false, :id => nil, :class => "edit department_#{department.id}  "}</td>
          <td>#{ check_box_tag 'staffs_settings[active_kpi][]', department.id, false, :id => nil, :class => "active_kpi department_#{department.id}"}</td>
          <td>#{ check_box_tag 'staffs_settings[active_bug][]', department.id, false, :id => nil, :class => "active_bug department_#{department.id} "}</td>
        </tr>\n"
      end
    else #Edit
      departments.each do |department|
        s << "
        <tr>
          <td>#{ toggle_checkboxes_link("input.department_#{department.id}")}#{  department.name}</td>
          <td>#{ check_box_tag 'staffs_settings[view][]',       department.id, staffs_settings.view.include?(department.id.to_s)       ? true :false, :id => nil, :class => "view department_#{department.id}  "} </td>
          <td>#{ check_box_tag 'staffs_settings[create][]',     department.id, staffs_settings.create.include?(department.id.to_s)     ? true :false, :id => nil, :class => "create department_#{department.id}"} </td>
          <td>#{ check_box_tag 'staffs_settings[edit][]',       department.id, staffs_settings.edit.include?(department.id.to_s)       ? true :false, :id => nil, :class => "edit department_#{department.id}  "} </td>
          <td>#{ check_box_tag 'staffs_settings[active_kpi][]', department.id, staffs_settings.active_kpi.include?(department.id.to_s) ? true :false, :id => nil, :class => "active_kpi department_#{department.id}" }</td>
          <td>#{ check_box_tag 'staffs_settings[active_bug][]', department.id, staffs_settings.active_bug.include?(department.id.to_s) ? true :false, :id => nil, :class => "active_bug department_#{department.id}" }</td>
        </tr>\n"
      end
    end
    s.html_safe
  end

  def auto_department_tags(name, principals)
    s = ''
    principals.each do |principal|
      s << "<label>#{ check_box_tag name, principal.id, false, :id => nil } #{h principal.name}</label>\n"
    end
    s.html_safe
  end

  def principals_check_box_tags(name, principals)
    s = ''
    principals.each do |principal|
      s << "<label>#{ check_box_tag name, principal.id, false, :id => nil } #{h principal.name}</label>\n"
    end
    s.html_safe
  end

  def pagination_links_full(*args)
    pagination_links_each(*args) do |text, parameters, options|
      if block_given?
        yield text, parameters, options
      else
        link_to text, {:params => request.query_parameters.merge(parameters)}, options
      end
    end
  end

  def staffs_settings_tabs
    tabs =
    [
      {:name => 'manager', :action => :staffs_settings, :partial => 'staffs_settings/manager', :label => :label_manager_staffs_tab},
      # {:name => 'custom_values', :action => :staffs_settings, :partial => 'staffs_settings/custom_values', :label => :label_custom_values_tab},
    ]
    tabs.select {|tab| tab[:action]}
  end
end
