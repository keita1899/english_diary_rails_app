module ApplicationHelper
  def page_title(title)
    base_title = 'English Diary'

    title.empty? ? base_title : "#{title} | #{base_title}"
  end
end
