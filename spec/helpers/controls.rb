require File.expand_path('../../spec_helper', __FILE__)

describe Activo::Rails::Helper, "control sets" do
  let(:view) { View.new }
  subject { view }

  it { should respond_to(:controls) }

  it "should yield a navigation builder" do
    view.controls do |c|
      c.should be_instance_of(Activo::Rails::Helper::NavigationBuilder)
    end
  end
end
