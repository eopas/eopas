module ApplicationHelper
  def error_messages(object)
    moo = ''
    if object.errors.any?
      moo = content_tag :div, :id => 'errorExplanation' do
        content_tag :h2, 'The following errors prohibited this form from being saved:'
        content_tag :ul do
          li = ''
          object.errors.full_messages.each do |msg|
            li << content_tag(:li, msg)
          end
          li
        end
      end
    end
    moo
  end
end
