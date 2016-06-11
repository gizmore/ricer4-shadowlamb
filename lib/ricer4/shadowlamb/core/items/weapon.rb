load File.expand_path("../armory.rb", __FILE__)
module Ricer4::Plugins::Shadowlamb::Core
  class Items::Weapon < Items::Armory
    
    def equipment_slot; :weapon; end

    def equipment_max_count(player); player.has_equipped?(:shield) ? 1 : 2; end
    
    def attack_time(attacker)
      40 + rand(0, 40)
    end

    def attack(attacker, defender)
      
      # Both parties
      attacker_party, defender_party = attacker.party, defender.party
      
      # 20 - 120% random success / power
      attacker_percent = dice_attack_percent(attacker)
      defender_percent = dice_defend_percent(defender)

      # Computed mostly by weapon relevant fields
      attacker_attack = (compute_attack(attacker) * attacker_percent).to_i
      defender_attack = (compute_defend(defender) * defender_percent).to_i

      # Final attack value to dice hits
      attack = clamp(attacker_attack - defender_attack)

      # Convert attack into hits
      # Each hit mean -1 HP      
      hits = 0
      attack.times.each{|n|hits += 1 if dice_hit}
      
      # Reduce hits by marm/farm
      armor = compute_armor(defender)
      damage = hits - armor
      damage = [defender.hp, damage].min

      #
      # Message args
      #
      message_args = {
        weapon: self,
        attacker: attacker.combat_stack.display_player,
        defender: defender.combat_stack.display_player,
        attacker_percent: lib.human_percent(attacker_percent,1),
        defender_percent: lib.human_percent(defender_percent,1),
        attacker_attack: attacker_attack,
        defender_attack: defender_attack,
        attack: attack,
        hits: hits,
        damage: damage,
      }

      # MISS: Check if more hits than defense? XXX      
      min_hits = 0 # defender.get_adjusted(:defense)
      if hits <= min_hits
        # Attacks, but misses
        return attacker_party.send_both_message_with_busy(
          attacker, "shadowlamb.msg_attack_missed", message_args
        )
      end
      
      if damage <= 0
        # Attacks, but no damage
        return attacker_party.send_both_message_with_busy(
          attacker, "shadowlamb.msg_attack_harmless", message_args
        )
      end
      
      # Kill it, with fire
      cause_damage(attacker, defender, self, damage)

      # Message it!
      if defender.dead?
        return attacker_party.send_both_message_with_busy(
          attacker, "shadowlamb.msg_attack_killed", message_args
        )
      else
        # Damaged!s
        message_args[:hp_status] = defender.display_hp
        return attacker_party.send_both_message_with_busy(
          attacker, "shadowlamb.msg_attack_damage", message_args
        )
      end
     
    end
    
  end
end
