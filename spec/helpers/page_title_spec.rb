require File.expand_path('../../spec_helper', __FILE__)

describe Activo::Rails::Helper, "setting the page title" do
  let(:view) { View.new }
  subject { view }
  
  it { should respond_to(:page_title) }
  
  it "sets the title attribute when #page_title is called with an argument" do
    view.page_title "Example"
    view.instance_variable_get("@title").should eq("Example")
  end

  it "returns the title when #page_title is called with no arguments" do
    view.page_title "A Title"
    view.page_title.should eq("A Title")
  end
end
