require 'spec_helper'

describe "Secondary Navigation" do
  before(:each) { visit "/secondary_navigation_test" }

  it "builds the wrapper around the menu" do
    page.should have_css "#without_id div.secondary-navigation ul.wat-cf"
  end

  it "applies provided options to the wrapper div" do
    page.should have_css "#with_id div.secondary-navigation#nav"
  end

  context "when rendering menu items" do
    it "displays the correct number of items" do
      page.all("#without_id div.secondary-navigation ul li").should have(2).elements
    end
  
    it "renders a link for each item" do
      page.all("#without_id div.secondary-navigation ul li a").should have(2).elements
    end
    
    it "displays Item 1 in the first position" do
      page.find("div.secondary-navigation ul li:first-child a").should have_content("Item 1")
    end
    
    it "displays Item 2 in the last position" do
      page.find("div.secondary-navigation ul li:last-child a").should have_content("Item 2")
    end

    it "sets the correct path for links" do
      href = page.find("div.secondary-navigation ul li:last-child a")["href"].should eq("/item2")
    end

    it "applies any classes to the node" do
      classes = page.find("#without_id div.secondary-navigation ul li:first-child")["class"]
      classes.split(" ").should include("foo")
    end

    it "passes link options to the link" do
      method = page.find("div.secondary-navigation ul li:last-child a")["data-method"]
      method.should eq("delete")
    end
  end
end
