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
    pending "displays the headline as an h2"
  end

  describe "with navigation" do
    pending "displays the navigation menu"
    pending "places the navigation menu at the top of the box"
  end
  
  describe "with breadcrumbs" do
    pending "displays the breadcrumbs"
    pending "places the breadcrumbs at the bottom of the box"
  end

  describe "with controls" do
    pending "displays the controls"
    pending "places the controls at the top of the box"
  end
end

