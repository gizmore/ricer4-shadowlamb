module Ricer4::Plugins::Shadowlamb::Core::Include::Spawns
    
  def self.included(base)
    base.extend Ricer4::Plugins::Shadowlamb::Core::Extend::SpawnsNpcs
  end
  
  def spawn_party
    party = Ricer4::Plugins::Shadowlamb::Core::Party.new()
    party.action = party.last_action = get_action(:created)
    player_factory.add_party(party)
    party
  end
  
  def spawn_human(user, race, gender)
    party = spawn_party
    human = spawn_player(race, gender, user)
    party.add_member(human)
    party.push_action(:spawning)
    player_factory.add_human(human)
    human
  end
  
  def spawn_player(race, gender, user=nil)
    race = Ricer4::Plugins::Shadowlamb::Core::Race.get_race(race) unless race.is_a?(Ricer4::Plugins::Shadowlamb::Core::Race)
    gender = Ricer4::Plugins::Shadowlamb::Core::Gender.get_gender(gender) unless gender.is_a?(Ricer4::Plugins::Shadowlamb::Core::Gender)
    player = Ricer4::Plugins::Shadowlamb::Core::Human.new({
      user: user,
      race: race,
      gender: gender,
    })
    player.build_player_values.modify.refresh
  end
  
  def clone_party(target_party)
    party = spawn_party
    party.set_lat_lon(target_party.latitude, target_party.longitude)
    action = target_party.is_inside? ? :inside : :outside
    party.push_action(action)
  end
  
  def spawn_real_npc(npc_pathes, target, action_name=:inside)
    if target.is_a?(:party) && [:fighting, :talking].include?(action_name)
      spawn_mob(npc_pathes)
    else
    end
  end
  
  # def spawn_stationary(npc_path, target, action_name=:inside)
#     
  # end

  def spawn_mob(mob_pathes, target_party, action_name=:fighting)
    
    action = get_action(action_name)

    # Interrupt the party
    target_party.interrupt!(action_name)
    
    # Use the already fighting enemy party, if possible
    mob_party = target_party.other_party rescue clone_party(target_party)
    
    # Create a mob 
    Array(mob_pathes).each do |mob_path|
      mob = mob_factory.spawn_npc(mob_path)
      mob_party.add_member(mob)
      player_factory.add_spawn(mob);
    end
    
    
    # Make them know of each other
    unless (target_party.action_is?(action_name))
      
      old_mob_action = mob_party.action
      old_mob_target = mob_party.target
      
      mob_party.action = action
      mob_party.target = action.target_id(mob_party, target_party)

      target_party.push_action(action_name, mob_party)
      
      mob_party.action = old_mob_action
      mob_party.target = old_mob_target

      mob_party.push_action(action_name, target_party)
    end
    
  end
end
