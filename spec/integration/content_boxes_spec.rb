require 'spec_helper'

describe "Content Boxes" do
  describe "with no addtional controls" do
    it "renders it's content" do
      visit '/content_boxes/vanilla'

      page.should have_css("div.block div.inner", :content => "Hello, world!")
    end
    
    it "applies any classes provided" do
      visit '/content_boxes/with_classes'

      page.should have_css("div.very.classy.block")
    end

    it "applies any ID provided" do
      visit '/content_boxes/with_id'

      page.should have_css("div.block#my_block")
    end
  end

  describe "with a headline" do
    before(:each) { visit '/content_boxes/with_headline' }
    
    it "displays the headline as an h2" do
      page.should have_css("div.block h2", :content => "Headline")
    end

    it "displays the headline as the first item in the content section" do
      page.should have_css("div.block div.content h2:first-child")
    end
  end

  describe "with navigation" do
    before(:each) { visit '/content_boxes/with_navigation' }
   
    it "displays the navigation menu" do
      page.should have_css("div.block div.secondary-navigation ul li", :content => "Home")
    end

    it "places the navigation menu at the top of the box" do
      page.should have_css("div.block div.secondary-navigation:first-child")
    end
  end
  
  describe "with breadcrumbs" do
    before(:each) { visit '/content_boxes/with_breadcrumbs' }
    
    it "displays the breadcrumbs" do
      page.should have_css("div.block div.breadcrumb ul li", :content => "Home")
    end

    it "places the breadcrumbs at the bottom of the box" do
      page.should have_css("div.block div.breadcrumb:last-child")
    end
  end

  describe "with controls" do
    before(:each) { visit '/content_boxes/with_controls' }

    it "displays the controls" do
      page.should have_css("div.block div.control a[href='/example']", :content => "Example Control")
    end

    it "places the controls at the top of the box" do
      page.should have_css("div.block div.control:first-child")
    end
  end
end

