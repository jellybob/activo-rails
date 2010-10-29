module ActivoRails
  module Helper
    # Creates a navigation menu.
    # - items should have the following format:
    #   {
    #     :content => "Link text",
    #     :href    => root_path,
    #     :class   => "active" # optional
    #   }
    def secondary_navigation(items = [])
      content_tag("div", :class => "secondary-navigation") do
        item_list("ul", items, :class => "wat-cf") do |item|
          content = item.delete(:content)
          content_tag("li") do
            content_tag("a", content, item)
          end
        end
      end
    end
    
    # Creates a set of buttons
    # - items should have the following format:
    #   {
    #     :label => "New Item",
    #     :href  => root_path,
    #     :icon  => "new_item"
    #   }
    # - icons are loaded from images/icons/16x16/ and assumed to be in png format.
    def controls(items = [])
      item_list("div", items, :class => "control") do |item|
        item[:class] << " button"
        content_tag("a", item[:class], :href => item[:href]) do
          image_tag("images/icons/16x16/#{item[:icon]}.png", :alt => item[:label]) + " "  + item[:label]
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
    def breadcrumbs(items = [])
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
  end
end
