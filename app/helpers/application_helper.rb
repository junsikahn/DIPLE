module ApplicationHelper
  def flash_class(level)
    case level
    when 'success' then 'ui green message'
    when 'notice'  then 'ui blue message'
    when 'error'   then 'ui yellow message'
    when 'alert'   then 'ui red message'
    else 'ui message'
    end
  end
end
