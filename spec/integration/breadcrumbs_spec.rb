require 'spec_helper'

describe "Breadcrumbs" do
  include Capybara

  before(:each) { visit '/breadcrumbs_test' }

  it "should create the breadcrumb wrapper" do
    page.should have_css "div.breadcrumb"
  end

  it "should merge any options with the wrapper div" do
    page.should have_css "div#foo.breadcrumb"
  end

  it "should wrap the items in an unordered list" do
    page.should have_css "div.breadcrumb ul"
  end

  it "should display the correct number of items" do
    page.all("ul li").should have(3).nodes
  end

  it "should render each inactive item as a link" do
    page.all("ul li a").should have(2).nodes
  end

  describe "the list items" do
    let(:items) { page.all("ul li") }

    it "should set the class of first on the first item" do
      items[0]["class"].should eq "first"
    end

    it "should set the class of active on the active item" do
      items[2]["class"].should eq "active"
    end

    it "should not link an active item" do
      items[2].should_not have_css "a"
    end

    it "should place the content of the active item directly in the list item" do
      items[2].should have_content "News Item 3"
    end

    it "should set specified classes when requested" do
      items[1]["class"].should eq "news"
    end
  end

  describe "the links" do
    let(:items) { page.all("ul li a") }

    it "should be displayed in the correct order" do
      items[0].should have_content "Home"
      items[1].should have_content "News"
    end

    it "should link to the correct locations" do
      items[0]["href"].should eq "/"
      items[1]["href"].should eq "/news"
    end
  end
end
