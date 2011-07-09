require File.expand_path('../../spec_helper', __FILE__)
require 'activo/rails/helper'
require 'nokogiri'
require 'active_support/dependencies/autoload'
require 'action_view'
require 'action_view/base'
require 'action_view/template/handlers/erb'

class View < ActionView::Base
  include Activo::Rails::Helper
  include ActionView::Helpers::TagHelper

  def asset_path(path)
    File.join("/assets", path)
  end
end

describe Activo::Rails::Helper do
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
      view.should_receive(:image_tag).with("/assets/activo-rails/icons/16x16/add.png", instance_of(Hash))
      view.icon("add")
    end

    it "creates the icon at 16x16 when size is small" do
      view.should_receive(:image_tag).with("/assets/activo-rails/icons/16x16/add.png", instance_of(Hash))
      view.icon("add", :small)
    end

    it "creates the icon at 32x32 when size is small" do
      view.should_receive(:image_tag).with("/assets/activo-rails/icons/32x32/add.png", instance_of(Hash))
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
    
    it "yields an instance of NavigationBuilder" do
      view.secondary_navigation do |nav|
        nav.should be_instance_of(Activo::Rails::Helper::NavigationBuilder)
      end
    end
  end

  describe "creating a control set" do
    it { should respond_to(:controls) }

    it "should yield a navigation builder" do
      view.controls do |c|
        c.should be_instance_of(Activo::Rails::Helper::NavigationBuilder)
      end
    end
  end

  describe "#breadcrumbs" do
    it { should respond_to(:breadcrumbs) } 

    it "should yield a navigation builder" do
      view.breadcrumbs do |b|
        b.should be_instance_of(Activo::Rails::Helper::NavigationBuilder)
      end
    end
  end
end
