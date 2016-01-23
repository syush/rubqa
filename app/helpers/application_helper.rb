module ApplicationHelper
  def author_id_of(object)
    object.user.id
  end

  def i_am_author_of(object)
    user_signed_in? && current_user.id == author_id_of(object)
  end
end
