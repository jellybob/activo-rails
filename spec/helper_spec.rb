require File.expand_path('../spec_helper', __FILE__)
require 'activo-rails/helper'
require 'nokogiri'
require 'active_support/dependencies/autoload'
require 'action_view'
require 'action_view/base'
require 'action_view/template/handlers/erb'

class View < ActionView::Base
  include ActivoRails::Helper
  include ActionView::Helpers::TagHelper
end

describe ActivoRails::Helper do
  let(:view) { View.new }
  subject { view }
  
  describe "setting the page title" do
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

  describe "#icon" do
    it { should respond_to(:icon) }
    
    it "creates an image tag containing the appropriate icon when called" do
      view.should_receive(:image_tag).with("/images/icons/16x16/add.png", instance_of(Hash))
      view.icon("add")
    end

    it "creates the icon at 16x16 when size is small" do
      view.should_receive(:image_tag).with("/images/icons/16x16/add.png", instance_of(Hash))
      view.icon("add", :small)
    end

    it "creates the icon at 32x32 when size is small" do
      view.should_receive(:image_tag).with("/images/icons/32x32/add.png", instance_of(Hash))
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

  describe "#secondary-navigation" do
    it { should respond_to(:secondary_navigation) }
    
    it "builds the wrapper around the menu" do
      content = view.secondary_navigation
    
      doc = Nokogiri::HTML(content)
      doc.css("div.secondary-navigation ul.wat-cf").should_not be_empty
    end

    it "applies provided options to the wrapper div" do
      content = view.secondary_navigation(:id => "nav")

      doc = Nokogiri::HTML(content)
      doc.css("div.secondary-navigation#nav").should_not be_empty
    end

    it "yields an instance of NavigationBuilder" do
      view.secondary_navigation do |nav|
        nav.should be_instance_of(ActivoRails::Helper::NavigationBuilder)
      end
    end
  
    context "when rendering menu items" do
      let(:menu) do
        content = view.secondary_navigation do |nav|
          nav.item "Item 1", "/", :class => "foo"
          nav.item "Item 2", "/item2"
        end

        Nokogiri::HTML(content)
      end

      it "displays the correct number of items" do
        menu.css("div.secondary-navigation ul li").should have(2).nodes
      end

      it "renders a link for each item" do
        menu.css("div.secondary-navigation ul li a").should have(2).nodes
      end
      
      it "displays Item 1 in the first position" do
        menu.css("div.secondary-navigation ul li:first-child a")[0].content.should eq("Item 1")
      end

      it "displays Item 2 in the last position" do
        menu.css("div.secondary-navigation ul li:last-child a")[0].content.should eq("Item 2")
      end
      
      it "sets the correct path for links" do
        href = menu.css("div.secondary-navigation ul li:last-child a")[0].attribute("href")
        href.value.should eq("/item2")
      end
      
      it "applies any classes to the node" do
        classes = menu.css("div.secondary-navigation ul li:first-child")[0].attribute("class")
        classes.value.split(" ").should include("foo")
      end
    end
  end
end
