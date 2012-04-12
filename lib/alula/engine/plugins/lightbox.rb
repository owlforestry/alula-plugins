require 'mini_exiftool'

module Alula
  class Engine
    class Plugins
      class Lightbox < Image
        register :lightbox
        
        def self.install(options)
          @@options = options

          # Return path to assets
          File.expand_path(File.join(File.dirname(__FILE__), *%w{.. .. .. .. plugins lightbox}))
        end
        
        # def prepare(markup, tokens)
        #   /(?<src>(?:https?:\/\/|\/|\S+\/)\S+)(?<title>\s+.+)?/ =~ markup
        #   /(?:"|')(?<title>[^"']+)?(?:"|')\s+(?:"|')(?<alt>[^"']+)?(?:"|')/ =~ title
        #   
        #   @name = src
        #   @title = title || ""
        #   @alt = alt || ""
        # end
        
        def content(context)
          # image = context.asset_url(File.join("images", @name))
          # thumbnail = context.asset_url(File.join("thumbnails", @name))
          image = source(@name, "images")
          thumbnail = source(@name, "thumbnails")
          
          unless image and thumbnail
            "<!-- Image #{@name} cannot be found. -->"
          else
            # binding.pry
            exif = MiniExiftool.new File.join(context.config.public_path, image)
            width, height = exif.imagewidth, exif.imageheight
            
            tag = "<a"
            tag += " class=\"fancybox\""
            tag += " rel=\"#{context.page.id}\""
            tag += " href=\"#{image}\""
            tag += " data-width=\"#{width}\""
            tag += " data-height=\"#{height}\""
            tag += " data-retina=\"#{retina(@name, "images")}\"" if context.config.images["retina"] and retina(@name, "images")
            tag += ">"
            tag += imagetag(@name, 'thumbnails')
            tag += "</a>"
          end
        end
      end
    end
  end
end