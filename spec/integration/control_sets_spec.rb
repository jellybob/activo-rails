require 'spec_helper'

describe "Control Sets" do
  before(:each) { visit "/control_sets_test" }
  
  it "should create the control wrapper" do
    page.should have_css "div.control"
  end

  it "should merge any provided options for the wrapper" do
    page.should have_css "div.control#foo"
  end
  
  it "should display the correct number of items" do
    page.all("div.control a").should have(2).nodes
  end

  it "should display each item in order" do
    page.find("div.control a:first-child").should have_content "Copy"
    page.find("div.control a:last-child").should have_content "Delete"
  end

  it "should link each item correctly" do
    page.find("div.control a:first-child")["href"].should eq "/people/2/copy"
    page.find("div.control a:last-child")["href"].should eq "/people/2"
  end

  it "should attach an icon when requested" do
    page.should have_css("div.control a:first-child img[alt='Copy person']")
  end
end
