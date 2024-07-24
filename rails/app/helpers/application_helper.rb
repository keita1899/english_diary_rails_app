module ApplicationHelper
  def page_title(title)
    base_title = 'English Diary'
    return base_title if title.empty?

    "#{title} | #{base_title}"
  end

  def input_error_class(object, field)
    'input-error' if object.errors[field].any?
  end

  def flash_class(level)
    case level
    when 'notice'
      'alert-info'
    when 'alert'
      'alert-error'
    else
      'alert'
    end
  end
end
