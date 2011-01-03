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
    
    it "returns an empty string when called with nil" do
      view.icon(nil).should eq("")
    end
    
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
          nav.item "Item 2", "/item2", :method => :delete
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

      it "passes link options to the link" do
        method = menu.css("div.secondary-navigation ul li:last-child a")[0].attribute("data-method")
        method.value.should eq("delete")
      end
    end
  end

  describe "creating a control set" do
    it { should respond_to(:controls) }

    it "should create the control wrapper" do
      content = view.controls

      doc = Nokogiri::HTML(content)
      doc.css("div.control").should_not be_empty
    end

    it "should merge any provided options for the wrapper" do
      content = view.controls(:id => "foo")
      
      doc = Nokogiri::HTML(content)
      doc.css("div.control#foo").should_not be_empty
    end
    
    it "should yield a navigation builder" do
      view.controls do |c|
        c.should be_instance_of(ActivoRails::Helper::NavigationBuilder)
      end
    end

    context "when rendering the controls" do
      def set_expectations
        view.should_receive(:icon).once.and_return(%Q{<icon img="copy_person" />})
      end

      let(:buttons) do
        set_expectations
        
        content = view.controls do |c|
          c.item "Copy", "/people/2/copy", :icon => "copy_person"
          c.item "Delete", "/people/2", :method => :delete
        end
        Nokogiri::HTML(content)
      end

      it "should display the correct number of items" do
        buttons.css("div.control a").should have(2).nodes
      end

      it "should display each item in order" do
        items = buttons.css("div.control a")
        items[0].content.should eq("Copy")
        items[1].content.should eq("Delete")
      end

      it "should link each item correctly" do
        items = buttons.css("div.control a")
        items[0].attribute("href").value.should eq("/people/2/copy")
        items[1].attribute("href").value.should eq("/people/2")
      end

      it "should attach an icon when requested" do
        buttons.css("div.control a icon[img='copy_person']").should have(1).node
      end
    end
  end

  describe "#breadcrumbs" do
    it { should respond_to(:breadcrumbs) } 

    it "should create the breadcrumb wrapper" do
      content = view.breadcrumbs
      
      doc = Nokogiri::HTML(content)
      doc.css("div.breadcrumb").should_not be_empty
    end

    it "should merge any options with the wrapper div" do
      content = view.breadcrumbs(:id => "foo")

      doc = Nokogiri::HTML(content)
      doc.css("div#foo.breadcrumb").should_not be_empty
    end

    it "should yield a navigation builder" do
      view.breadcrumbs do |b|
        b.should be_instance_of(ActivoRails::Helper::NavigationBuilder)
      end
    end

    context "when provided with some breadcrumbs" do
      let(:breadcrumbs) do
        content = view.breadcrumbs do |b|
          b.item "Home", "/"
          b.item "News", "/news/", :class => "news"
          b.item "Awesome New Things", "/news/awesome-new-things", :active => true
        end
        Nokogiri::HTML(content)
      end
      
      it "should wrap the items in an unordered list" do
        breadcrumbs.css("div ul").should_not be_empty
      end

      it "should display the correct number of items" do
        breadcrumbs.css("ul li").should have(3).nodes
      end

      it "should render each inactive item as a link" do
        breadcrumbs.css("ul li a").should have(2).nodes
      end
      
      describe "the list items" do
        let(:items) { breadcrumbs.css("ul li") }

        it "should set the class of first on the first item" do
          items[0].attribute("class").value.should eq("first")
        end

        it "should set the class of active on the active item" do
          items[2].attribute("class").value.should eq("active")
        end
        
        it "should not link an active item" do
          items[2].css("a").should be_empty
        end
        
        it "should place the content of the active item directly in the list item" do
          items[2].content.should eq("Awesome New Things")
        end

        it "should set specified classes when requested" do
          items[1].attribute("class").value.should eq("news")
        end
      end

      describe "the links" do
        let(:items) { breadcrumbs.css("ul li a") }
        
        it "should be displayed in the correct order" do
          items[0].content.should eq("Home")
          items[1].content.should eq("News")
        end

        it "should link to the correct locations" do
          items[0].attribute("href").value.should eq("/")
          items[1].attribute("href").value.should eq("/news/")
        end
      end
    end
  end
end
