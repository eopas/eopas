module ApplicationHelper
  def error_messages(object)
    html = ''
    if object.errors.any?
      html = content_tag :div, :id => 'errorExplanation' do
        content_tag :h2, 'The following errors prohibited this form from being saved:'
        content_tag :ul do
          li = ''
          object.errors.full_messages.each do |msg|
            li << content_tag(:li, msg.html_safe)
          end
          li.html_safe
        end
      end
    end
    html.html_safe
  end
end
