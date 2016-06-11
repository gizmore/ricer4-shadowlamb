module Ricer4::Plugins::Shadowlamb
  class Start < Core::Command
    
    include Ricer4::Plugins::Shadowlamb::Core::Include::Spawns
    
    trigger_is :start
    requires_player false
      
    has_usage  '<sl_race> <sl_gender>', function: :execute_start
    def execute_start(race, gender)
      begin
        human = spawn_human(sender, race, gender)
        human.party.set_lat_lon(52.321712, 10.235685)
        race.sl5_player_created(human)
        arm_publish('player/created', human)
        human.party.save_party!
        rply :msg_created
      rescue => e
        begin
          bot.log.exception(e)
          byebug
          human.party.destroy_party!
          rply :err_failed
        rescue
        end
      end
    end
      
  end
end
