class ApplicationController < ActionController::Base
  protect_from_forgery
  layout "activo"

  def secondary_navigation_test
  end

  def control_sets_test
  end

  def breadcrumbs_test
  end
end
