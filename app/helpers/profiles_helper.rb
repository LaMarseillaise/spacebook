module ProfilesHelper
  def edit_profile_button(user, css_class=nil)
    if current_user && user == current_user
      link_to 'Edit Profile', edit_profile_path, class: css_class, remote: true
    end
  end
end
