# Activo Rails #

This gem provides a Rails 3 engine which makes using the Activo web application theme
a more pleasant process.

It places all the required assets in the right places, and
provides an application layout, saving you from having to strip out the relevant bits
and build it yourself everytime.

There are also a few view helpers available to simplify the creation of common UI elements
such as button lists, breadcrumbs, and menus.

## Installing ##

To install the theme add the following line to your application's Gemfile:

    gem "activo-rails"

Update your bundle, and then in your application controller set the layout:

    class ApplicationController < ActionController::Base
      layout "activo"
    end

If you only want to use Activo in some controllers, then you should only set the layout in those
controllers, and the rest of the application will continue to use your default layout.

## Hello, World! ##

A basic view, with a single content block, and a page title would look something like this.

    <% page_title "Hello, world!" %>

    <div class="block">
      <div class="content">
        <h2>Hello, World!</h2>
        <div class="inner">
          <p>This is a basic Activo template.</p>
        </div>
      </div>
    </div>

Unfortunatly there's a bit of divitis involved in using Activo. I'd like to reduce that with
some more helpers, but I'm not entirely sure how to do so cleanly at the moment. It's probably
worth it though.

If you're using a decent text editor, it should be automatable anyway.

If you're interested in a scaffold, check out the themed generator from web-app-theme (https://github.com/pilu/web-app-theme).

## View Helpers ##

There are a few view helpers available to use which deal with some of the more awkward parts of
Activo.

### Setting the Page Title ###

As shown in the previous example, you can call `page_title` to set the title to be displayed.

    <% page_title "My Lovely Page" %>

### Icons ###

To display icons use the `icon` helper. Activo includes the Fatcow icons from www.fatcow.com/free-icons,
which are licensed under the Creative Commons Attribution 3.0 license. It's up to you to either
comply with that license, or replace them with something else.

    <%= icon "delete", :large, :alt => "Delete Item" %>

The first argument is the filename of the icon, without extension.

The second is the size. :small gives a 16x16 icon, :large gives 32x32.

Finally, a hash of options. Currently the only valid option is :alt which sets the alt text to be
included in the image tag. Further options will probably be supported in the future.

### Navigation Tabs ####

The `secondary_navigation` helper is used to add some tabs to the top of a content block.
    
    <% page_title "About Us" %>

    <div class="block">
      <%= secondary_navigation do |n|
        n.item "The Company", about_path("company"), :active => true
        n.item "Our Offices", about_path("offices")
        n.item "Jobs", about_path("jobs"), :class => "highlighted"
      end %>
      <div class="content">
        <h2>About Us</h2>
        <div class="inner">
          <p>We're an amazing company! We do things!</p>
          <p>To find out more, click the tabs above.</p>
        </div>
      </div>
    </div>

Each item can be passed a hash of options. Valid options are:

  active (boolean): If set to true, the tab will be highlighted as the current tab.
  class (string): Additional classes to apply to the tab.
  link\_options (hash): A hash of options to pass to link\_to.

### Breadcrumbs ###

These are much like tabs, but appear at the bottom of a block as a trail of pages.
They're added using the `breadcrumbs` helper.

    <% page_title "News Item 3" %>

    <div class="block">
      <div class="content">
        <h2>News Item 3</h2>
        <div class="inner">
          <p>We've got some new news here. Read all about it!</p>
        </div>
      </div>
      <%= breadcrumbs do |b|
        b.item "Home", root_path
        b.item "News", news_path
        b.item "News Item 3", news_path(3), :active => true
      end %> 
    </div>

Valid options are the same as for tabs.

### Controls ###

To add a set of buttons to the top of a block, use the `controls` helper.

    <% page_title "News Item 3 (Admin Mode)" %>

    <div class="block">
      <div class="content">
        <%= controls do |c|
          c.item "Delete", news_path(3), :link_options => { :method => :delete, :confirm => "Really delete News Item 3?" }, :icon => "delete"
          c.item "Edit", edit_news_path(3), :icon => "edit"
        end %>
        <h2>News Item 3</h2>
        <div class="inner">
          <p>We've got some new news here. Read all about it!</p>
        </div>
      </div>
    </div>

Valid options are the same as for tabs, with an additional `icon` option, which will be passed
to the `icon` helper.

## Adding to the header ##

To add content to the header, you have two choices, depending on how often you need to do so.

### yield :head ###

If you just need to add something on a single page, provide some content for the head block:

    <% content_for :head do %>
      <script>
        console.log('This is in the header now.')
      </script>
    <% end %>

### def head ###

If you're going to want the content more regularly, you can create a helper called head, which 
will be called at the appropriate place:

    def head
      content_tag("script", "console.log('This is in the header now.')")
    end

## Customising the Layout ##

You probably want to add a few menus of your own, and maybe a sidebar as well. That's done by
providing some helpers within your application which if they exist will be called by Activo to
fill in the empty spaces.

### Navigation ###

The main and user navigation areas at the top of the page are populated in the same way. The main
navigation is the text based one on the left hand side, while the user navigation is the row of icons
on the right.

To populate them create a helper called either `main_navigation` or `user_navigation`. The method
will be passed a NavigationBuilder instance which can be filled with items.
    
    module ApplicationHelper
      def main_navigation(menu)
        menu.item "Home", root_path
        menu.item "News", news_path, :active => true
      end
    end

When populating the user navigation you probably want to make the first argument a call to `image_tag`
since the space available isn't big enough for anything other icons.

### Status ###

In the top right, opposite the logo, there's a section which can be filled with text to notify your users
of important information. If a `status_menu` helper exists, the return value will be used to fill that space.
    
    module ApplicationHelper
      def status_menu
        "Welcome back Jon!"
      end
    end

### The Sidebar ###

The sidebar is filled by a `sidebar` helper if one exists.
    
    module ApplicationHelper
      def sidebar
        content_tag("div", :class => "block") do
          content_tag("ul", :class => "navigation") do
            content_tag("li", link_to("News Item 3", news_path(3)))
          end
        end
      end
    end

It's probably easier to render a partial here, especially if your sidebar is going to change frequently.

### Hiding the Sidebar ###

If you don't want a sidebar at all you can expand the content area to fill the available space. Set the `full_width`
instance variable to do so.

    class ApplicationController < ActionController::Base
      before_filter :hide_sidebar
      
      def hide_sidebar
        @full_width = true
      end
      protected :hide_sidebar
    end

## Using Formtastic ##

Activo is already set up to be used with Formtastic, but doesn't directly depend on it, since form
builders are very much a matter of taste.

If you would like to use it (and I recommend it), then just add `gem 'formtastic'` to your Gemfile, and almost everything will work out of the box.

Currently, if you'd like activo style buttons, you'll need to manually generate them, as the formtastic helper hasn't been updated to emit buttons yet. It should be coming for the 2.1 release. See https://github.com/justinfrench/formtastic/issues/11

Also, the theme doesn't support the formtastic way of emitting buttons. Until this is all cleared up, if you want pretty buttons, your markup needs to be as follows:

	<div class="group navform wat-cf">
			<button class="button" type="submit">
				<img src="stylesheets/themes/activo/images/icons/tick.png" alt="Save"> Save
			</button>
			<a href="#header" class="button">
				<img src="stylesheets/themes/activo/images/icons/cross.png" alt="Cancel"> Cancel
			</a>
		</div>

If you've used the web-app-theme themed generator, you'll need to manually update your forms to use formtastic. 

## web-app-theme ##

This theme is compatible with the generators from web-app-theme (https://github.com/pilu/web-app-theme). Some of the markup has diverged hasn't been fully tested. If you find issues, please fork and submit a pull.

## Contributing ##

This is currently a very young gem. I'm using it in a couple of projects quite happily, but it could certainly
use some smoothing out of the edges, and more view helpers. If you want to contribute, fork this repository, and
send me a pull request when your feature is ready.

Any contributions should come with accompanying tests, examples of which can be found in the spec/ directory.

To test that the right content is being generated make modifications to the application in spec/dummy/ and then
add a new integration test for it in spec/integration/. I know not everything is covered by integration tests yet.
That's no excuse not to write them for new features ;)

The test suite can be run by using `rake spec`.

## Credits ##

For the original (and beautiful) Activo web app theme: David Francisco (http://github.com/dmfrancisco/activo)
Icons: FatCow (http://www.fatcow.com/free-icons)

Fixing jQuery UI image paths: Mike Park (http://github.com/mikepinde/)

Fixing link options, and breadcrumbs: Nirmit Patel (http://github.com/NeMO84/)

And thanks to the people brave enough to use this before it was released, or even had a readme, for provoking me into actually releasing the damn thing.

## License ##

All original components of activo-rails are licensed under the MIT license:

Copyright (c) 2011, Blank Pad Development

That doesn't cover the Activo theme itself, the FatCow icon set, or jQuery, which remain under their original licenses 
and the property of their original authors.
