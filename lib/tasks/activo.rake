namespace :activo do
  paths = {
    :stylesheets => "app/assets/stylesheets/activo-rails",
    :images      => "app/assets/images/activo-rails",
    :fonts       => "app/assets/fonts/activo-rails",
    :javascripts => "app/assets/javascripts/activo-rails"
  }

  desc 'clone the current activo2 version from github and store it in activo'
  task :download_from_git do
    puts "checking out activo2"
    `rm -rf activo`
    `git clone https://github.com/dmfrancisco/activo.git --branch activo-2`
  end

  # upgrade activo2 from the official repository
  desc 'upgrade to current activo-rails stable version'
  task :move_files => :download_from_git do
    puts "clearing asset folder"
    `rm -rf app/assets`
    
    %w(images javascripts stylesheets).each do |folder|
      puts "moving #{folder}"
      `mkdir -p #{paths[folder.to_sym]}`
      `mv activo/#{folder}/* #{paths[folder.to_sym]}`
    end
    
    puts "moving ui-images to asset folder"
    `mkdir #{paths[:images]}/ui/`
    `mv #{paths[:stylesheets]}/images/* #{paths[:images]}/ui/`
    
    %w(images fonts).each do |folder|
      puts "moving the theme assets (#{folder})"
      `mkdir -p #{paths[folder.to_sym]}`
      `mv #{paths[:stylesheets]}/themes/activo/#{folder}/* #{paths[folder.to_sym]}`
    end
    
    puts "removing compiled style.css"
    `rm #{paths[:stylesheets]}/themes/activo/style.css`
    
    puts "moving application.js to datepicker.js"
    `mv #{paths[:javascripts]}/application.js #{paths[:javascripts]}/datepicker.js`
  end
  
  desc 'rename all stylesheets to work with sprockets'
  task :prepare_stylesheets => :move_files do
    stylesheets_with_assets = [
      'jquery-ui.css',
      'uniform.default.css',
      'themes/activo/formtastic_changes.sass',
      'themes/activo/style.sass',
      'themes/activo/fonts.sass'
    ]
    
    puts "building asset map"
    asset_map = Dir.glob('app/assets/**/*.*').inject({}) do |mem, var|
      file = var.gsub(%r(^app/assets/.*?/), '')
      mem[File.basename(file)] = file
      mem
    end

    puts "cleaning stylesheets to work with sprockets"
    stylesheets_with_assets.each do |file|
      new_filename = "#{paths[:stylesheets]}/#{file}.erb"
      puts "renaming #{file} to #{file}.erb"
      `mv #{paths[:stylesheets]}/#{file} #{new_filename}`
      
      File.open(new_filename, 'r+') do |file|
        data = file.read
        
        puts "removing @import statements"
        data.gsub!(/\n(@import ([^\n]+))/) do |match|
          match =~ /mixins/ ? match : ''
        end
        
        puts "scanninng for assets"
        regex = /url\(\'?(.*?)\'?\)/
        data.gsub!(regex) do |url|
          path = url.match(regex)[1]
          parts = File.basename(path).match(/([^#]+)(#.+)?/)
          if asset = asset_map[parts[1]]
            puts "replacing #{parts[1]} with #{asset}"
            "url('<%= asset_path '#{asset}' %>#{parts[2]}')"
          else
            url
          end
        end
        file.rewind
        file.write(data)
      end
    end
  end
  
  task :create_application_files => :prepare_stylesheets do
    puts "creating application.js"
    File.open("#{paths[:stylesheets]}/application.css.scss", 'w+') do |file|
      data = <<EOF
#=require ./base
#=require ./jquery-ui
#=require ./formtastic
#=require ./jquery.tipsy
#=require ./uniform.default
#=require ./themes/activo/fonts
#=require ./themes/activo/formtastic_changes
#=require ./themes/activo/attrtastic_changes
#=require ./themes/activo/style
EOF
      file.write(data)
    end
    
    puts "creating application.js"
    File.open("#{paths[:javascripts]}/application.js", 'w+') do |file|
      data= <<EOF
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require ./jquery.scrollTo
//= require ./jquery.localscroll
//= require ./jquery.tipsy
//= require ./jquery.uniform.min
//= require ./datepicker
EOF
      file.write(data)
    end
  end
  
  task :upgrade => :create_application_files do
    puts "done with upgrading activo2"
  end
end