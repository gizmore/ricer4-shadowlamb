module Ricer4::Plugins::Shadowlamb
  class Gmt < Core::Command
    
    trigger_is :gmt
    
    permission_is :responsible
    
    include Ricer4::Plugins::Shadowlamb::Core::Include::Spawns
      
    has_usage  '<sl_player> <..message..>', function: :execute_spawn_mob

    def execute_spawn_mob(player, message)
      begin
        # Test pathes
        npc_pathes = message.split(/[ ,\t;.]+/)
        npc_pathes.each do |npc_path|
          npc_path.replace(mob_factory.npc_path_i18n(npc_path))
          mob_factory.npc_klass(npc_path)
        end
        spawn_mob(npc_pathes, player.party, action_name=:fighting)
      rescue Core::UnknownNpc => e
        reply e.to_s
      end
    end
    
  end
end
