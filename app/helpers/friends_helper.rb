module FriendsHelper
  def friend_button(target)
    if current_user.friends.include?(target)
      label, method, action, css_class = "Unfriend", "DELETE", :destroy, "btn btn-danger"
    elsif current_user.friended_users.include?(target)
      label, method, action, css_class = "Withdraw Request", "DELETE", :destroy, "btn btn-warning"
    elsif current_user.users_friended_by.include?(target)
      label, method, action, css_class = "Accept Friend Request", "POST", :create, "btn btn-success"
    else
      label, method, action, css_class = "Send Friend Request", "POST", :create, "btn btn-primary"
    end

    unless current_user == target
      link_to label,
              url_for(controller: 'friends', id: target.id, action: action),
              method: method,
              remote: true,
              class: css_class, id: "friend-#{target.id}"
    end
  end

  def decline_button(target)
    if current_user.friend_requests.include?(target)
      link_to "Decline", friend_path(target), method: "DELETE", data: { confirm: "Are you sure you want to decline #{target.name}'s friend request?"}, class: "btn btn-danger"
    end
  end
end
