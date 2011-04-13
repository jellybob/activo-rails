require 'activo/rails/helper'

module Activo::Rails
  class Engine < Rails::Engine
    config.mount_at = '/activo/'
    ActionController::Base.helper Activo::Rails::Helper

    initializer "static assets" do |app|
      app.middleware.insert_after ::ActionDispatch::Static, ::ActionDispatch::Static, File.join(root, "public")
    end
  end
end
