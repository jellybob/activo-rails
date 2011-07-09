module Activo
  module Rails
    module Helper
      # Create a content box.
      #
      # options - A hash of options to apply to the box.
      # &block - The content of the box, passed an instance of BoxBuilder.
      #
      # Valid options:
      #
      # * :headline -- The headline to show in the box.
      # * :class -- A class to apply to the box.
      # * :id -- The ID to apply to the box.
      #
      # Example:
      #   <% content_box :headline => "My Box", :class => "alert", :id => "my_box" do |box| %>
      #     <% box.navigation do |nav| %>
      #       <% nav.item "List People", people_path, :active => true %>
      #       <% nav.item "New Person", new_person_path %>
      #       <% nav.item "Search", search_path(:type => "people") %>
      #     <% end %>
      #
      #     <% box.breadcrumbs do |crumbs| %>
      #       <% crumbs.item "Home", root_path %>
      #       <% crumbs.item "People", people_path %>
      #       <% crumbs.item "Bob Jones", person_path(@person), :active => true %>
      #     <% end %>
      #
      #     <p>This is a really neat box, which will be displayed with a headline and navigation.</p>
      #   <% end %>
      # 
      # Returns the completed box, yields an instance of BoxBuilder.
      def content_box(options = {}, &block)
        box_buffer = BoxBuilder.new(self)
        box_content = capture(box_buffer, &block)
        
        content_tag(:div, :class => 'block') do
          block_out = box_buffer.buffers[:block_header].html_safe
          block_out << content_tag(:div, :class => 'content') do
            content_out = ''
            content_out = content_tag(:h2, options[:headline]) if options[:headline]
            content_out << content_tag(:div, box_content, :class => 'inner')
          end
          block_out << box_buffer.buffers[:block_footer].html_safe
        end
      end
      
      # Get or set the page title
      # 
      # title - The title to set. (optional)
      # 
      # Example:
      #   page_title("Hello, world!")
      #   # => "Hello, world!"
      #   page_title
      #   # => "Hello, world!"
      #   
      # Returns the page title, first setting it if title is not nil.
      def page_title(title = nil)
        @title = title unless title.nil?
        @title
      end
      
      # Display an icon
      # 
      # name - The icon to display
      # size - One of :small or :large (optional)
      # options - A hash to be passed to the image_tag helper (optional)
      # 
      # Example:
      #   icon("add")
      #   # => image_tag("/assets/activo-rails/icons/16x16/add.png", :alt => "Add")
      #   icon("new_item", :large)
      #   # => image_tag("/assets/activo-rails/icons/32x32/new_item.png, :alt => "New Item")
      #   
      # Returns an image tag, ready to be displayed in a template.
      def icon(name, size = :small, options = {})
        return "" if name.nil?
        
        dimension = ( (size == :small) ? "16" : "32" ).html_safe
        options[:alt] ||= name.capitalize.gsub("_", " ")
        
        image_tag(asset_path("activo-rails/icons/#{dimension}x#{dimension}/#{name}.png"), {
          :alt => options[:alt]
        })
      end
      
      def navigation(options = {}, &block)
        options[:class] ||= ""
        options[:class].strip!
        
        menu = NavigationBuilder.new
        yield menu if block_given?
        
        content_tag("div", options) do
          content_tag("ul", "", :class => "wat-cf") do
            menu.collect { |item|
              content_tag("li", :class => item[:class]) do
                link_to(item[:label], item[:href], item[:link_options])
              end
            }.join("").html_safe
          end
        end
      end

      # Displays a secondary naviagtion menu
      # 
      # options - A hash of attributes to apply to the wrapping div tag
      # 
      # Example:
      #   <div class="block">
      #     <%= secondary_navigation do |nav|
      #       nav.item "List People", people_path, :active => true
      #       nav.item "New Person", new_person_path
      #       nav.item "Search", search_path(:type => "people")
      #     end %>
      #     <div class="content">
      #       <h2 class="title">List People</h2>
      #     </div>
      #   </div>
      #   
      # Returns a secondary navigation block to be displayed.
      def secondary_navigation(options = {}, &block)
        options[:class] ||= ""
        options[:class] << " secondary-navigation"
        
        navigation(options, &block)
      end
      
      # Creates a set of buttons
      # 
      # options - A hash of attributes to apply to the wrapping div tag
      # 
      # Example:
      #   <div class="block">
      #     <div class="content">
      #       <%= controls do |c|
      #         c.item "Copy", copy_person_path(person), :icon => "copy_person"
      #         c.item "Delete", person_path(person), :method => :delete
      #       end %>
      #     </div>
      #   </div>
      #   
      # Returns a set of controls to be displayed.
      def controls(options = {})
        options[:class] ||= ""
        options[:class] << " control"
        options[:class].strip!
        
        items = NavigationBuilder.new
        yield items if block_given?
        
        content_tag("div", options) do
          items.collect { |item|
            item[:label] = (icon(item[:icon]) + item[:label]).html_safe if item[:icon]
            link_to(item[:label], item[:href], item[:link_options].merge(:class => "button"))
          }.join("").html_safe
        end
      end
      
      # Displays a breadcrumb trail
      # 
      # options - A hash of attributes to apply to the wrapping div tag
      # 
      # Example:
      #   <div class="block">
      #     <div class="content">
      #       <h2><%= @news_item.title %></h2>
      #       <p><%= @news_item.content %></p>
      #     </div>
      #     <%= breadcrumbs do |b|
      #       b.item "Home", root_path
      #       b.item "News", news_path
      #       b.item "Awesome New Things", news_path(@news_item), :active => true
      #     %>
      #   </div>
      # 
      # Returns the breadcrumb trail.
      def breadcrumbs(options = {})
        items = NavigationBuilder.new
        yield items if block_given?
        
        options[:class] ||= ""
        options[:class] << " breadcrumb"
        options[:class].strip!
        
        content_tag("div", options) do
          content_tag("ul") do
            items.collect { |item|
              content_tag("li", :class => item[:class]) do
                if item[:active]
                  item[:label]
                else
                  link_to(item[:label], item[:href])
                end
              end
            }.join("").html_safe
          end
        end
      end
      
      # Assists in the creation of navigation menus
      class NavigationBuilder
        attr_reader :item_list
        include Enumerable
        
        def initialize
          @item_list = []
        end
        
        def each(&blk)
          item_list.each(&blk)
        end

        def item(label, path, options = {})
          options[:class] ||= ""
          options[:class] << " first" if item_list.empty?
          options[:class] << " active" if options[:active]
                  
          options[:link_options] ||= {}
          options[:link_options].merge!(:method => options[:method]) if options[:method]
          
          item_list << {
            :label => label,
            :href => path,
            :class => options[:class].strip,
            :link_options => options[:link_options],
            :icon => options[:icon],
            :active => !!options[:active]
          }
        end
      end
    
      # Provides a container for boxes that are currently being constructed.
      class BoxBuilder
        # :nodoc:
        attr_reader :buffers
        
        # :nodoc:
        def initialize(parent)
          @parent = parent
          @buffers = { :block_header => '', :block_footer => '' }
        end
        
        # Sets the controls to display in this box. See Activo::Rails::Helper#controls.
        def controls(options = {}, &block)
          buffers[:block_header] << @parent.controls(options, &block)
          ''
        end

        # Sets the navigation to display on this box. See Activo::Rails::Helper#navigation.
        def navigation(options = {}, &block)
          buffers[:block_header] << @parent.secondary_navigation(options, &block)
          ''
        end

        # Sets the breadcrumbs to display in this box. See Activo::Rails::Helper#breadcrumbs.
        def breadcrumbs(options = {}, &block)
          buffers[:block_footer] << @parent.breadcrumbs(options, &block)
          ''
        end
      end
    end
  end
end
