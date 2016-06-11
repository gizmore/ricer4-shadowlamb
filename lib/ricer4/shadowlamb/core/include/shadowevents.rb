module Ricer4::Plugins::Shadowlamb::Core::Include::Shadowevents

  ############################################
  ### Wrapper for static publish/subscribe ###
  ############################################
  # def self.included(base)
    # # Include ricer core events
    # #base.extend Ricer4::Extend::Events
  # end
  # # Ricer core events wrappers
  # def all_subscriptions; self.class.all_subscriptions; end
  # def event_subscriptions(event); self.class.event_subscriptions(event); end
  # def subscribe(event, &block); self.class.subscribe(event, &block); end
  # def publish(event, *event_args); self.class.publish(event, *event_args); end
  
  ###
  ### Known old-style funcion / inheritance "events"
  ###
  def sl5_after_cause_damage(attacker, victim, with, damage); end
  def sl5_after_kill(killer, victim, with, damage); end
  def sl5_after_killed(killer, victim, with, damage); end
  def sl5_after_take_damage(attacker, victim, with, damage); end
  def sl5_after_spawned_for(npc, party); end

  def sl5_ai_plugin_init(options={}); end # Init an ai plugin, can be inited / added multiple times

  def sl5_before_cause_damage(attacker, victim, with, damage); end
  def sl5_before_kill(killer, victim, with, damage); end
  def sl5_before_killed(killer, victim, with, damage); end
  def sl5_before_take_damage(attacker, victim, with, damage); end

  def sl5_get_sell_items(player); end
  def sl5_get_shop_items(player); end
  
  def sl5_npc_before_definition; end
  def sl5_npc_after_definition; end
  def sl5_npc_after_spawned_for(party); end

  def sl5_on_being_used(player, object); end

  def sl5_on_say(player, message); end
  def sl5_on_shout(player, message); end
  def sl5_on_tell(player, message); end

  def sl5_on_using_with(player, object); end
  
  # def sl5_on_party_enters_area(party, old_area, new_area); end
  # def sl5_on_party_leaves_area(party, old_area, new_area); end
  # def sl5_on_party_enters_location(party, old_location, new_location); end
  # def sl5_on_party_leaves_location(party, old_location, new_location); end
   
  def sl5_on_killed_xp(killer, victim, with); 0; end
  def sl5_on_killed_nuyen(killer, victim, with); 0; end
  def sl5_on_killed_items(killer, victim, with); []; end
  def sl5_on_killed_loot(killer, victim, with); []; end
  def sl5_on_killed_equipment(killer, victim, with); []; end
  def sl5_on_killed_inventory(killer, victim, with); []; end

  def sl5_is_kill_protected?(killer, victim); false; end
  def sl5_is_loot_protected?(killer, victim); false; end
  
  def sl5_can_exit_area?(party, old_area, new_area); true; end
  def sl5_can_enter_area?(party, old_area, new_area); true; end
  def sl5_can_exit_location?(party, location); true; end
  def sl5_can_enter_location?(party, location); true; end
  

end
