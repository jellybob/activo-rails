module ActivoRails
  class Engine < Rails::Engine
    config.asset_path = "/activo/%s"
  end
end
