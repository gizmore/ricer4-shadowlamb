module Ricer4::Plugins::Shadowlamb::Core
  class Ground
    
    include Include::Base
    include Include::Translates
    arm_events
    include Include::SpawnsItems

    arm_subscribe('party/stopped/fighting') do |sender, party|
      ground = party.ground
      ground.distribute_loot
      ground.clear_ground
    end
    
    arm_subscribe('party/after/fighting') do |sender, party|
      party.pop_action if party.enemy_party.dead?
    end
    
#    arm_subscribe('player/after/killed') do |sender, killer, victim, with, damage|
#      killer.party.ground.sl5_after_killed(killer, victim, with, damage)
#    end

    def initialize(party)
      @party = party
      clear_ground
    end
    
    def sl5_before_killed(killer, victim, with, damage)
      ny = push_nuyen(killer, victim, with)
      xp = push_xp(killer, victim, with)
      items = item_factory.create_loot_for(killer, victim, with)
      push_items(killer, items, with)
      victim.send_message(t(:msg_you_got_killed_by,
        killer: killer.display_name,
        with: with.display_name,
        damage: damage,
        xp: xp,
        nuyen: ny,
        items: display_items(items),
     ))
    end
    
    def clear_ground
      @shared_xp, @shared_nuyen = 0, 0
      @player_xp, @player_nuyen = {}, {}
      @killer_items, @loot_items = {}, {}
      self
    end
    
    def push_nuyen(killer, victim, with)
      total_ny = victim.sl5_on_killed_nuyen(killer, victim, with)||0
      share_ny = killr_ny = (total_ny / 2).to_i
      killr_ny += 1 if (total_ny % 1) == 1
      @shared_nuyen += share_ny
      @player_nuyen[killer] ||= 0
      @player_nuyen[killer] += killr_ny
      total_ny
    end
    
    def push_xp(killer, victim, with)
      total_xp = victim.sl5_on_killed_xp(killer, victim, with)||0
      share_xp = killr_xp = (total_xp / 2).to_i
      killr_xp += 1 if (total_xp % 1) == 1
      @shared_xp += share_xp
      @player_xp[killer] ||= 0
      @player_xp[killer] += killr_xp
      total_xp
    end
    
    def push_items(killer, items, with)
      @killer_items[killer] ||= []
      @killer_items[killer] += items
      items
    end

    def distribute_loot
      distribute_items
      @party.members.each do |member|
        distribute_loot_to(member)
      end
      self
    end

    def distribute_items
      if @party.loot_mode == Party::LOOT_KILLER
        @loot_items = @killer_items
      else
        @killer_items.each do |killer, items|
          items.each do |item|
            distribute_item(ki)
          end
        end
      end
      @killer_items = {}
    end

    def distribute_item(killer, item)
      member = nil
      case @party.loot_mode
      when Party::LOOT_CYCLE; member = @party.loot_cycle_member
      when Party::LOOT_RANDOM; member = @party.members.sample
      end
      raise StandardError.new("No member wants to loot?!") if member.nil?
      @loot_items[member] = item
    end
    
    def distribute_loot_to(player)
      byebug
      membercount = @party.membercount
      xp = @player_xp[player]||0
      xp += (@shared_xp / membercount).round
      nuyen = @player_nuyen[player]||0
      nuyen += (@shared_nuyen / membercount).round
      items = @loot_items[player]||[]
      return if (nuyen <= 0) && (xp <= 0) && (items.count == 0)
      player.give_items(items)
      karmachange = ""
      player.localize!.send_message(loot_message_for(player, xp, nuyen, karmachange, itemslooted_text(items)))
    end
    
    def itemslooted_text(items)
      items.count == 0 ? '' : (' ' + t(:you_itemloot, items: display_items(items)))
    end
    
    def loot_message_for(player, xp, nuyen, karmachange, itemslooted)
      t("shadowlamb.msg_loot", xp: xp, nuyen: nuyen) + karmachange + itemslooted
    end
    
  end
end
