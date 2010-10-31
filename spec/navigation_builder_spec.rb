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
  end

  it { should respond_to(:item_list) }
  describe "the item list" do
    it "defaults to an empty array" do
      builder.item_list.should eq([])
    end
  end
end
