module Alula
  module Plugins
    class Lightbox < Liquid::Tag
      def self.install(options)
        @@options = options
        
        # Register custom tag
        Liquid::Template.register_tag('lightbox', Alula::Plugins::Lightbox)
        
        # Register attachment insertion
        Alula::Plugins.register_attachment_handler(:image, ->(asset){
          "{% lightbox #{asset} %}"
        })
        
        # Return path to assets
        File.expand_path(File.join(File.dirname(__FILE__), *%w{.. .. .. plugins lightbox}))
      end
      
      def initialize(tag_name, markup, tokens)
        /(?<src>(?:https?:\/\/|\/|\S+\/)\S+)(?<title>\s+.+)?/ =~ markup
        /(?:"|')(?<title>[^"']+)?(?:"|')\s+(?:"|')(?<alt>[^"']+)?(?:"|')/ =~ title
        
        @name = src
        @title = title || ""
        @alt = alt || ""
      end

      def render(context)
        asset_path = context.registers[:site].config["asset_path"]
        manifest = context.registers[:site].config["manifest"]
        
        original = File.join(asset_path, manifest.assets[File.join("images", @name)])
        thumbnail = File.join(asset_path, manifest.assets[File.join("thumbnails", @name)])
        
        # Fetch image size
        img = Magick::Image.read(File.join("public", thumbnail)).first
        width = img.columns
        height = img.rows
        
        tag = "<a class=\"fancybox\" rel=\"#{context.environments.first["page"]["id"]}\" href=\"#{original}\">"
        tag += "<img src=\"#{thumbnail}\" alt=\"#{@alt}\" title=\"#{@title}\" width=\"#{width}\" height=\"#{height}\">"
        tag += "</a>"
      end
    end
  end
end
