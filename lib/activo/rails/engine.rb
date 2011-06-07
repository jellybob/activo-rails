require 'activo/rails/helper'

module Activo::Rails
  class Engine < Rails::Engine
    ActionController::Base.helper Activo::Rails::Helper
  end
end
