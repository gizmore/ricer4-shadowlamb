module Ricer4::Plugins::Shadowlamb
  class Attack < Core::Command
    
    is_combat_trigger :attack
    
    works_when :fighting
    
    has_usage  '<sl_near_enemy>', function: :_execute_attack

    def _execute_attack(defender)
      execute_attack(player, defender)
    end
    
    def execute_attack(attacker, defender)
      # Remember choice
      attacker.combat_target = defender
      # Sometime
      combat_command(attacker, true) do
        weapon = attacker.weapon.item_object
        attacker.busy(weapon.attack_time(attacker))
        weapon.attack(attacker, defender)
      end
    end
    
    def execute_random_attack(attacker)
      defender = attacker.enemy_party.members.sample
      execute_attack(attacker, defender) unless defender.nil?
    end
    
  end
end
