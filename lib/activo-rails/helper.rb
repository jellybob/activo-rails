module ActivoRails
  module Helper
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
    #   # => image_tag("/images/icons/16x16/add.png", :alt => "Add")
    #   icon("new_item", :large)
    #   # => image_tag("/images/icons/32x32/new_item.png, :alt => "New Item")
    #   
    # Returns an image tag, ready to be displayed in a template.
    def icon(name, size = :small, options = {})
      dimension = (size == :small) ? "16" : "32"
      options[:alt] ||= name.capitalize
      
      image_tag("/images/icons/#{dimension}x#{dimension}/#{name}.png", {
        :alt => options[:alt]
      })
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
    def secondary_navigation(options = {})
      options[:class] ||= ""
      options[:class] << " secondary-navigation"
      options[:class].strip!
      
      menu = NavigationBuilder.new
      yield menu if block_given?
      
      content_tag("div", options) do
        content_tag("ul", "", :class => "wat-cf") do
          menu.item_list.collect { |item|
            content_tag("li", :class => item[:class]) do
              link_to(item[:label], item[:href])
            end
          }.join("")
        end
      end
    end

#    def secondary_navigation(*items)
#      content_tag("div", :class => "secondary-navigation") do
#        item_list("ul", items, :class => "wat-cf") do |item|
#          content = item.delete(:content)
#          content_tag("li") do
#            content_tag("a", content, item)
#          end
#        end
#      end
#    end
    
    # Creates a set of buttons
    # - items should have the following format:
    #   {
    #     :label => "New Item",
    #     :href  => root_path,
    #     :icon  => "new_item"
    #   }
    # - icons are loaded from images/icons/16x16/ and assumed to be in png format.
    def controls(*items)
      item_list("div", items, :class => "control") do |item|
        item[:class] ||= ""
        item[:class] = item[:class].split(" ")
        item[:class] << "button"
        content_tag("a", item[:class].join(" "), :href => item[:href]) do
          icon(item[:icon], :small, :alt => item[:label]) + " "  + item[:label]
        end
      end
    end

    # Creates a breadcrumb trail
    # - items should have the following format:
    #   {
    #     :label => "Item 1",
    #     :href  => root_path,
    #     :active => true
    #   }
    def breadcrumbs(*items)
      content_tag("div", :class => "breadcrumb") do
        item_list("ul", items) do |item|
          active = item.delete(:active)
          content = item.delete(:label)
          href = item.delete(:href)
          item[:class] << " active" if active

          content_tag("li", item) do
            if item[:active]
              content
            else
              link_to(content, href)
            end
          end
        end
      end
    end

    def item_list(tag, items, tag_options = {}, &template)
      content_tag(tag, tag_options) do
        first = true
        list = items.collect do |item|
          classes = []
          classes << item[:class].split(" ") if item[:class]
          if first
            classes << "first"
            first = false
          end
          item[:class] = classes.join(" ")
          yield item
        end
        list.join("")
      end
    end
    
    # Assists in the creation of navigation menus
    class NavigationBuilder
      attr_reader :item_list
      
      def initialize
        @item_list = []
      end

      def item(label, path, options = {})
        options[:class] ||= ""
        options[:class] << " first" if item_list.empty?
        options[:class] << " active" if options[:active]
        
        item_list << {
          :label => label,
          :href => path,
          :class => options[:class].strip
        }
      end
    end
  end
end
