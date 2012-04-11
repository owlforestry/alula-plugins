require 'mini_exiftool'

module Alula
  class Engine
    class Plugins
      class Lightbox < Tag
        register :lightbox
        
        def self.install(options)
          @@options = options

          # Return path to assets
          File.expand_path(File.join(File.dirname(__FILE__), *%w{.. .. .. plugins lightbox}))
        end
        
        def prepare(markup, tokens)
          /(?<src>(?:https?:\/\/|\/|\S+\/)\S+)(?<title>\s+.+)?/ =~ markup
          /(?:"|')(?<title>[^"']+)?(?:"|')\s+(?:"|')(?<alt>[^"']+)?(?:"|')/ =~ title
          
          @name = src
          @title = title || ""
          @alt = alt || ""
        end
        
        def content(context)
          image = context.asset_url(File.join("images", @name))
          thumbnail = context.asset_url(File.join("thumbnails", @name))
          
          unless image and thumbnail
            "<!-- Image #{@name} cannot be found. -->"
          else
            exif = MiniExiftool.new File.join(context.config.public_path, thumbnail)
            width, height = exif.imagewidth, exif.imageheight
            
            tag = "<a class=\"fancybox\" rel=\"#{context.page.id}\" href=\"#{image}\">"
            tag += "<img src=\"#{thumbnail}\" alt=\"#{@alt}\" title=\"#{@title}\" width=\"#{width}\" height=\"#{height}\">"
            tag += "</a>"
          end
        end
      end
    end
  end
end