module Ricer4::Plugins::Shadowlamb
  class Sleep < Core::Command

    trigger_is :sleep
    
    requires_leadership

    def enabled?
      party.inside_location_provides?(:sleep)
    end

    has_usage ''
    def execute
      return rply :err_not_sleepy unless party_sleepy?(party)
      player.party.push_action(:sleeping)
      rply :msg_sleeping
    end
    
    def party_sleepy?(party)
      get_action(:sleeping).party_sleepy?(party)
    end
    
  end
end
