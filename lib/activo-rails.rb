module ActivoRails
  class Engine < Rails::Engine
    config.mount_at = '/activo/'
    
    initializer "static assets" do |app|
      app.middleware.use ::ActionDispatch::Static, "#{root}/public"
    end
  end
end
