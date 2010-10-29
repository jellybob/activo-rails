module ActivoRails
  class Engine < Rails::Engine
    puts "Loaded engine"
    config.asset_path = "/activo/%s"
  end
end
