require File.expand_path('../../spec_helper', __FILE__)

describe Activo::Rails::Helper, "breadcrumbs" do
  let(:view) { View.new }
  subject { view }

  it { should respond_to(:breadcrumbs) } 

  it "should yield a navigation builder" do
    view.breadcrumbs do |b|
      b.should be_instance_of(Activo::Rails::Helper::NavigationBuilder)
    end
  end
end
