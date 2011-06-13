require 'activo/rails/helper'

module Activo::Rails
  class Engine < Rails::Engine
    ActionController::Base.helper Activo::Rails::Helper
    
    # strange: seems to have no effect at all
    # config.asset_path = "/activo-rails%s" 
  end
end
