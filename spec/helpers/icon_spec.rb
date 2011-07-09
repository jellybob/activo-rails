require File.expand_path('../../spec_helper', __FILE__)

describe Activo::Rails::Helper, "displaying icons" do
  let(:view) { View.new }
  subject { view }

  it { should respond_to(:icon) }
  
  it "returns an empty string when called with nil" do
    view.icon(nil).should eq("")
  end
  
  it "creates an image tag containing the appropriate icon when called" do
    view.should_receive(:image_tag).with("/assets/activo-rails/icons/16x16/add.png", instance_of(Hash))
    view.icon("add")
  end

  it "creates the icon at 16x16 when size is small" do
    view.should_receive(:image_tag).with("/assets/activo-rails/icons/16x16/add.png", instance_of(Hash))
    view.icon("add", :small)
  end

  it "creates the icon at 32x32 when size is small" do
    view.should_receive(:image_tag).with("/assets/activo-rails/icons/32x32/add.png", instance_of(Hash))
    view.icon("add", :large)
  end

  it "sets the alt attribute to the icon name by default" do
    view.should_receive(:image_tag).with(duck_type(:to_s), {
      :alt => "Add"
    })
    view.icon("add", :small)
  end

  it "sets the alt attribute to the provided value if provided" do
    view.should_receive(:image_tag).with(duck_type(:to_s), {
      :alt => "An icon"
    })
    view.icon("add", :small, :alt => "An icon")
  end
end
