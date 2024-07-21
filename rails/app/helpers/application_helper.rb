module ApplicationHelper
  def page_title(title)
    base_title = 'English Diary'
    return base_title if title.empty?

    "#{title} | #{base_title}"
  end
end
