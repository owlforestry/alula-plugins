require 'alula/core_ext/tags/video'
require 'alula/plugin'

module Alula
  class Sublimevideo < VideoTag
    def self.asset_path
      File.join(File.dirname(__FILE__), %w{.. .. .. plugins sublimevideo})
    end
    
    def self.install(options)
      # Display license unless acknoledged
      return false unless options.token
      
      # Register addons
      Alula::Plugin.addon :head, ->(context) {
        "<script src=\"http://cdn.sublimevideo.net/js/#{options.token}.js\"></script>" if context.item.content[/\<video/]
      }
      
      # Register for image tags
      Alula::Tag.register :video, self
    end
    
    def content
      sublime_videotag(@source)
    end
    
    def sublime_videotag(source)
      poster = source.gsub(/#{File.extname(source)}$/, '.png')
      info = info(poster, :thumbnail)
      poster = attachment_url(poster, :thumbnail)
      tag =  "<a"
      tag += " class=\"sublime zoomable\""
      tag += " href=\"#{sources.first[:url]}\""
      tag += " style=\"width: #{info.width}px; height: #{info.height}px;\""
      tag += ">"
      tag += " <img"
      tag += "  src=\"#{poster}\""
      tag += "  alt=\"#{@alt}\""
      tag += "  width=\"#{info.width}\" height=\"#{info.height}\""
      tag += "  />"
      tag += "  <span class=\"zoom_icon\"></span>"
      tag += "</a>"
      
      info = info(sources.first[:name], :video)
      tag += "<video"
      tag += " controls"
      tag += " class=\"sublime lightbox\""
      tag += " style=\"display: none;\""
      tag += " width=\"#{info.width}\""
      tag += " height=\"#{info.height}\""
      tag += " poster=\"#{poster}\""
      tag += " preload=\"none\""
      tag += " data-uid=\"#{source}\""
      tag += ">"
      
      sources.each do |source|
        tag += "  <source src=\"#{source[:url]}\" #{source[:hires] ? "data-quality=\"hd\"" : ""} />"
      end
      
      tag += "</video>"
      
    end
  end
end

Alula::Plugin.register :sublimevideo, Alula::Sublimevideo
