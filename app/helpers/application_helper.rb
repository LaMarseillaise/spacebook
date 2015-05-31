module ApplicationHelper
  def interactive_navbar
    if signed_in?
      render 'shared/search'
    else
      render 'shared/sign_in'
    end
  end

  def delete_button(object)
    if object.author == current_user
      link_to "Delete", object, method: "DELETE",
        data: { confirm: "Are you sure you want to delete?" }, remote: true
    end
  end
end
