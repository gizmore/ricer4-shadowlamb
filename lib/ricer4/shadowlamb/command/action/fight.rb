module Ricer4::Plugins::Shadowlamb
  class Fight < Core::Command
    
    trigger_is :fight
    
    works_when :inside, :outside, :knocking, :talking
    
    has_usage '<sl_near_player>', function: :_execute_fight
    
    def _execute_fight(defender)
      raise Ricer4::ExecutionException(t(:err_enemy_not_idle)) unless defender.is_idle?
      execute_fight(player, defender)
    end
    
    def execute_fight(attacker, defender)
      kill_protection_error!(attacker, defender) if attacker.party.sl5_is_kill_protected(attacker, defender)
      attacker_party, defender_party = attacker.party, defender.party
    end
    
    def kill_protection_error!(attacker, defender)
      raise Ricer4::ExecutionException.new(t(:err_kill_protected,
        players: defender.party.display_members,
      )) 
    end
    
  end
end
