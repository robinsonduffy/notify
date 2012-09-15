module ApplicationHelper

  def page_title
    base_title = "Notification App"
    if(@title.nil?)
      base_title
    else
      "#{@title} | #{base_title}"
    end
  end
end
