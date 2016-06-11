module Ricer4::Plugins::Shadowlamb
  class Perf < Core::Command
    
    trigger_is :perf

    has_usage '', function: :execute_performance
    
    def execute_performance
      core = Ricer4::Plugins::Shadowlamb::Core
      rply :msg_perf,
        players: core::Player.count,
        items: core::Item.count,
        values: core::Value.count
    end
      
  end
end
