module Ricer4::Plugins::Shadowlamb
  class Gmdbcleanup < Core::Command
    
    trigger_is :gmdbcleanup
    
    permission_is :responsible
      
    requires_retype

    has_usage '', function: :_execute_cleanup
    def _execute_cleanup
      execute_cleanup
      rply :msg_cleanup
    end
    
    def plugin_init
      execute_cleanup
    end

    def execute_cleanup
      deleted_parties = 0
      Core::Party.all.each do |party|
        begin
          if party.membercount == 0
            party.destroy!
            deleted_parties += 1
          end
        rescue => e
          byebug
          puts e
        end
      end
      bot.log.info("Cleaned #{deleted_parties} parties.")
    end
    
  end
end
