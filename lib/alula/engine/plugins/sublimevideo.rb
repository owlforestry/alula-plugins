require 'mini_exiftool'

module Alula
  class Engine
    class Plugins
      class Sublimevideo < Video
        register :video
        
        def self.install(options)
          @@options = options
          
          Plugins.addon :head, ->(context){
            "<script src=\"http://cdn.sublimevideo.net/js/#{options["token"]}.js\" type=\"text/javascript\"></script>" if context.page.content[/\<video/]
          }

          # # Register attachment insertion
          # Alula::Plugins.register_attachment_handler(:video, ->(assets){
          #   "{% video #{assets} %}"
          # })
          #         
          # Return path to assets
          File.expand_path(File.join(File.dirname(__FILE__), *%w{.. .. .. .. plugins sublimevideo}))
        end

        def prepare(markup, tokens)
          super
          # @class = "sublime zoom"
          # @style = "display: none;"
          # @controls = false
        end
      
        def content(context)
          exif = MiniExiftool.new File.join("public", poster)
          
          tag = " <a class=\"sublime zoomable\" href=\"#{sources.first}\" style=\"width: #{exif.imagewidth}px; height: #{exif.imageheight}px;\">"
          tag += "  <img src=\"#{poster}\" alt=\"\" width=\"#{exif.imagewidth}\" height=\"#{exif.imageheight}\" />"
          tag += "  <span class=\"zoom_icon\"></span>"
          tag += "</a>"
          
          exif = MiniExiftool.new File.join("public", sources.first)
          tag += "<video"
          tag += " class=\"sublime lightbox\""
          tag += " style=\"display: none;\""
          tag += " width=\"#{exif.imagewidth}\" height=\"#{exif.imageheight}\" poster=\"#{poster}\" preload=\"none\""
          tag += " data-uid=\"#{@name}\""
          tag += ">"
          
          sources.each do |src|
            exif = MiniExiftool.new File.join("public", src)
            hd = (exif.imageheight >= 720 or exif.imagewidth >= 720)
            tag << "  <source src=\"#{src}\" #{hd ? "data-quality=\"hd\"" : ""} />"
          end
          tag << "</video>"
        end
      end
    end
  end
end
