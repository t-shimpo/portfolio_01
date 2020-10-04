module ApplicationHelper
  # タイトル名Webapp要変更
  def document_title
    if @title.present?
      "#{@title} | Webapp"
    else
      'Webapp'
    end
  end
end
