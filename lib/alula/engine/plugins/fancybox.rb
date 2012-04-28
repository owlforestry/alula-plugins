require 'mini_exiftool'

module Alula
  class Engine
    class Plugins
      class Fancybox < Image
        register :image
        
        def self.install(options)
          @@options = options
          
          # Display notice
          unless options.kind_of?(Hash) and options["personal"]
            puts <<-end_of_notice
*** fancyBox
Please note, that fancyBox is licensed under the therms of the
Creative Commons Attribution-NonCommercial 3.0 License
(http://creativecommons.org/licenses/by-nc/3.0/).

If you would like to use fancyBox for commercial purposes,
you can purchase a license from http://fancyapps.com/store/
              
To remove this notice, please include following options in config.yml
---
plugins:
  fancybox:
    personal: true
  
              end_of_notice
          end
          
          # Return path to assets
          File.expand_path(File.join(File.dirname(__FILE__), *%w{.. .. .. .. plugins fancybox}))
        end
        
        def content(context)
          image = source(@src, "images")
          thumbnail = source(@src, "thumbnails")
          
          unless image and thumbnail
            # Not an attachment, fall back to regular image tag
            super
          else
            exif = MiniExiftool.new File.join(context.config.public_path, image)
            # Set name and prefix for metadata
            width, height = exif.imagewidth, exif.imageheight
            
            tag = "<a"
            tag += " class=\"fancybox\""
            tag += " href=\"#{image}\""
            tag += " data-width=\"#{width}\""
            tag += " data-height=\"#{height}\""
            tag += " data-hires=\"#{hires(@src, "images")}\"" if context.config.images["hires"] and hires(@src, "images")
            tag += " data-fancybox-group=\"#{context.page.id}\""
            tag += " title=\"#{self.title}\"" if self.title
            tag += ">"
            tag += imagetag(@src, 'thumbnails')
            tag += "</a>"
          end
        end
      end
    end
  end
end