require 'alula/plugin'

module Alula
  class Analytics
    def self.path
      File.join(File.dirname(__FILE__), %w{.. .. .. plugins analytics})
    end
    
    def self.install(options)
      return false unless options.kind_of?(Hash)
      
      options.each do |provider, opts|
        if provider == "gosquared"
          Alula::Plugin.addon(:body, ->(context) {<<-EOT
            <script type="text/javascript">
              var GoSquared={};
              GoSquared.acct = "#{opts}";
              (function(w){
                function gs(){
                  w._gstc_lt=+(new Date); var d=document;
                  var g = d.createElement("script"); g.type = "text/javascript"; g.async = true; g.src = "//d1l6p2sc9645hc.cloudfront.net/tracker.js";
                  var s = d.getElementsByTagName("script")[0]; s.parentNode.insertBefore(g, s);
                }
                w.addEventListener?w.addEventListener("load",gs,false):w.attachEvent("onload",gs);
              })(window);
            </script>
            EOT
            })
        end
      end
    end
  end
end

Alula::Plugin.register :analytics, Alula::Analytics
