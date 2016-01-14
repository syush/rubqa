module ApplicationHelper
  def author_id_of(object)
    object.user.id
  end
end
