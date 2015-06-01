module LikesHelper
  def like_button(likable)
    if user_like = likable.likes.find_by_liker_id(current_user.id)
      link_to "Unlike", user_like, method: "DELETE", remote: true
    else
      link_to "Like", likes_path(like: {likable_type: likable.class, likable_id: likable.id}), method: "POST", remote: true
    end
  end

  def likes_count(likable)
    scale = likable.likes_count

    case scale
    when 0
      string = false
    when 1
      string = "#{likable.likers[0].name} likes this."
    when 2
      string = "#{likable.likers[0].name} and #{likable.likers[1].name} like this."
    else
      string = "#{likable.likers[0].name}, #{likable.likers[1].name}, and #{pluralize(scale - 2, 'other person')} like this."
    end

    string ? content_tag(:div, string, :class => 'col-xs-12 like-count') : nil
  end
end
