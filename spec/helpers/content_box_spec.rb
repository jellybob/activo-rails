require File.expand_path('../../spec_helper', __FILE__)

describe Activo::Rails::Helper, "content_box" do
  let(:view) { View.new }
  subject { view }

  it { should respond_to("content_box") } 

  it "should yield a box builder" do
    view.content_box(:headline => "My Box") do |b|
      b.should be_instance_of(Activo::Rails::Helper::BoxBuilder)
    end
  end

  it "should build without a headline" do
    lambda { view.content_box { |b| "Hello, world" } }.should_not raise_exception
  end
end

