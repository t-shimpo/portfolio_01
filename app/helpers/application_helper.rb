module ApplicationHelper
  def document_title
    if @title.present?
      "#{@title} | MyBooks"
    else
      'MyBooks'
    end
  end
end
