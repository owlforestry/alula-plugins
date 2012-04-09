module Alula
  module Plugins
    class Videojs < Alula::Plugins::VideoAsset
      def self.install(options)
        @@options = options
        
        # Register head script hook
        if options['hosted']
          Alula::Plugins.register_content_for_head("<link href=\"http://vjs.zencdn.net/c/video-js.css\" rel=\"stylesheet\">\n<script src=\"http://vjs.zencdn.net/c/video.js\"></script>")
        end
        
        # Register attachment insertion
        Alula::Plugins.register_attachment_handler(:video, ->(assets){
          "{% video #{assets} %}"
        })
        
        # Return path to assets
        File.expand_path(File.join(File.dirname(__FILE__), *%w{.. .. .. plugins videojs}))
      end

      def initialize(tag_name, markup, tokens)
        super
        @class = "video-js vjs-default-skin"
        @controls = true
      end
      
      def render(context)
        output = super
        output.gsub(/^<video/, "<video data-setup=\"{}\"")
      end
    end
  end
end

Liquid::Template.register_tag('video', Alula::Plugins::Videojs)
