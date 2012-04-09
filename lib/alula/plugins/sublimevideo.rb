module Alula
  module Plugins
    class Sublimevideo < Alula::Plugins::VideoAsset
      def self.install(options)
        @@options = options
        
        # Register head script hook
        Alula::Plugins.register_scripts_for_head("<script src=\"http://cdn.sublimevideo.net/js/#{options["token"]}.js\" type=\"text/javascript\"></script>")
        
        # Register attachment insertion
        Alula::Plugins.register_attachment_handler(:video, ->(assets){
          "{% video #{assets} %}"
        })
        
        # Return path to assets
        File.expand_path(File.join(File.dirname(__FILE__), *%w{.. .. .. plugins sublimevideo}))
      end

      def initialize(tag_name, markup, tokens)
        super
        @class = "sublime zoom"
        @style = "display: none;"
      end
      
      def render(context)
        output = super
        exif = MiniExiftool.new File.join("public", @poster)
        
        tag = " <a class=\"sublime zoomable\" href=\"#{@srcs.first}\" style=\"width: #{exif.imagewidth}px; height: #{exif.imageheight}px;\">\n"
        tag << "  <img src=\"#{@poster}\" alt=\"\" />\n"
        tag << "  <span class=\"zoom_icon\"></span>\n"
        tag << "</a>\n"
        tag << output
      end
    end
  end
end

Liquid::Template.register_tag('video', Alula::Plugins::Sublimevideo)
