class PluginIssue < Issue

  safe_attributes(
    'actual_end_date',
    :if => lambda {|issue, user| issue.new_record? || issue.attributes_editable?(user)}
  )
end