module Ricer4::Plugins::Shadowlamb
  class Time < Core::Command
    
    trigger_is "sr.time"
    
    has_usage ''
    
    def execute
      
      rply :msg_time, time: l(shadowtime)
      
    end
    
      
  end
end
