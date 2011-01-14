module ApplicationHelper
  def main_navigation(menu)
    menu.item "Home", root_path, :active => true
    menu.item "News", root_path
  end

  def user_navigation(menu)
    menu.item image_tag("/images/session/home.png", :title => "Home"), root_path
  end
  
  def sidebar
    render :partial => "shared/sidebar"
  end

  def status_menu
    "Welcome to Activo Rails!"
  end
end
