require File.expand_path("../spec_helper", __FILE__)

describe ActivoRails::Helper::NavigationBuilder do
  let(:builder) { ActivoRails::Helper::NavigationBuilder.new } 
  subject { builder }

  it { should respond_to(:item) }
  describe "adding items to the menu" do
    it "appends the item to the item list" do
      builder.item("New Item", "")
      builder.item("Item 2", "")

      builder.item_list.collect { |item| item[:label] }.should eq([
        "New Item",
        "Item 2"
      ])
    end
    
    it "sets the path to the one provided" do
      builder.item("New Item", "/new")
      builder.item_list.first[:href].should eq("/new")
    end

    it "sets the first class on the first item to be added" do
      builder.item("New Item", "")
      builder.item("Item 2", "")

      builder.item_list[0][:class].should match(/first/)
      builder.item_list[1][:class].should_not match(/first/)
    end

    it "sets the active class on an item with the active option set" do
      builder.item("New Item", "")
      builder.item("New Item", "", :active => true)

      builder.item_list[0][:class].should_not match(/active/)
      builder.item_list[1][:class].should match(/active/)
    end

    it "defaults link_options to an empty hash" do
      builder.item("New Item", "")
      builder.item_list[0][:link_options].should eq({})
    end

    it "sets the method on link_options if provided" do
      builder.item("New Item", "", :method => :delete)
      builder.item_list[0][:link_options].should eq({ :method => :delete })
    end

    it "sets the icon if provided" do
      builder.item("New Item", "", :icon => "new")
      builder.item_list[0][:icon].should eq("new")
    end

    it "defaults the icon to the title if not provided" do
      builder.item("Delete", "")
      builder.item_list[0][:icon].should eq("delete")
    end
  end

  it { should respond_to(:item_list) }
  describe "the item list" do
    it "defaults to an empty array" do
      builder.item_list.should eq([])
    end
  end

  describe "iteration" do
    it { should respond_to(:each) }
    it { should respond_to(:collect) }
  end
end
