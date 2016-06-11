module Ricer4::Plugins::Shadowlamb
  class Wakeup < Core::Command

    trigger_is :wakeup
    
    requires_leadership
    
    works_when :sleeping

    has_usage ''
    def execute
      execute_wakeup(party)
    end
    
    def execute_wakeup(party)
      party.send_message('ricer.plugins.shadowlamb.wakeup.msg_woke_up')
      party.pop_action()
    end
    
  end
end
