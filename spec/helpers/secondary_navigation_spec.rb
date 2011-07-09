require File.expand_path('../../spec_helper', __FILE__)

describe Activo::Rails::Helper, "secondary navigation menus" do
  let(:view) { View.new }
  subject { view }

  it { should respond_to(:secondary_navigation) }
  
  it "yields an instance of NavigationBuilder" do
    view.secondary_navigation do |nav|
      nav.should be_instance_of(Activo::Rails::Helper::NavigationBuilder)
    end
  end
end
