require 'activo/rails/helper'
require 'active_support/dependencies/autoload'
require 'action_view'
require 'action_view/base'
require 'action_view/template/handlers/erb'

class View < ActionView::Base
  include Activo::Rails::Helper
  include ActionView::Helpers::TagHelper

  def asset_path(path)
    File.join("/assets", path)
  end
end
