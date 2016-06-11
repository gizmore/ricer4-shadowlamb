#### TODO: DONT WANT THIS FILE ANYMORE?
module Ricer4::Plugins::Shadowlamb::Core
  class PlayerFactory
    
#    include Singleton
    def self.instance; @instance ||= self.new; end
    
    arm_events
    
    include Include::Base
    include Include::Spawns
    
    attr_reader :players, :parties, :humans, :npcs, :mobs, :stationary, :realnpc
    
    def initialize
      @players, @parties = [], []
      @humans, @npcs, @mobs, @stationary, @realnpc = [], [], [], [], []
    end
    
    ##############
    ### Loader ###
    ##############
    def startup_active_parties
      # bot.log.debug("PlayerFactory#startup_active_parties")
      # shadowverse.mutex.synchronize do
      # Human.human.joins(:user).where(:online => true).each do |player|
        # add_human(player.becomes!(Human))
      # end
        Player.all.each do |player|
          #if player.npc_id.nil? && player.user_id.nil?
            #byebug
          #else
            cast_and_load_player(player)
          #end
  #        if party.is_active?
            #  cast_and_load_player(player)
#            if party.is_fighting_mobs?
#              party.pop_action
#            end
  #        end
        end
        bot.log.info("PlayerFactory#startup_active_parties: #{@players.count} players and #{@parties.count} parties loaded.")
      # end
    end

    def cast_and_load_player(player)
      if player.npc_id.nil?
        load_player(Human.find(player.id))
      else
        cast_and_load_npc(player)
      end
    end

    def cast_and_load_npc(player)
      npc_klass = mob_factory.npc_klass_by_npc_id(player.npc_id)
      load_player(npc_klass.find(player.id))
    end
    
    def load_player(player)
      if player.is_a?(Mob); add_mob(player)
      elsif player.is_a?(RealNpc); add_real_npc(player)
      elsif player.is_a?(StationaryNpc); add_stationary(player)
      else; add_human(player)
      end
    end
    
    def load_stationary_npcs
      bot.log.debug("PlayerFactory#load_stationary_npcs")
      mob_factory.npc_classes.each do |npc_path, klass|
        load_stationary_npc(npc_path, klass) if klass < StationaryNpc
      end
    end
    
    def load_stationary_npc(npc_path, klass)
      bot.log.debug("PlayerFactory#load_stationary_npc(#{npc_path}, #{klass.name})")
      npc_id = NpcName.npc_id_for_path(npc_path)
      npc = klass.where(:npc_id => npc_id).first
      return create_stationary_npc(npc_path, klass) unless npc
      bot.log.debug("LOADED PlayerFactory#load_stationary_npc(#{npc_path}, #{klass.name})")
      npc
    end
    
    def create_stationary_npc(npc_path, klass)
      bot.log.debug("PlayerFactory#create_stationary_npc(#{npc_path}, #{klass.name})")
      npc = mob_factory.spawn_npc(npc_path)
      party = spawn_party
      party.add_member(npc)
      party.set_lat_lon(npc.stationary_lat, npc.stationary_lon)
      party.push_action(npc.stationary_action)
      party.save_party!
      add_stationary(npc)
    end
    
    ###############
    ### Parties ###
    ###############
    def add_party(party)
      raise Ricer4::ConfigException.new("Added party is nil!") if party.nil?
      return if @parties.include?(party)
      @parties.push(party)
      if party.persisted?
        arm_publish('party/loaded', party)
      else
        arm_publish('party/created', party)
      end
#      party.save!
    end
    
    def remove_party(party)
      @parties.delete(party)
    end
    
    def party_by_id(id)
      @parties.each do |party|
        return party if party.id = id
      end
      raise Ricer4::ConfigException.new("player_factory#party_by_id failed for: #{id}")
    end

    def party_by_object_id(object_id)
      @parties.each do |party|
        return party if party.object_id == object_id
      end
      bot.log.debug("PlayerFactory#party_by_object_id(#{object_id}) failed!")
      raise Ricer4::Plugins::Shadowlamb::Core::PartyGone.new("player_factory#party_by_object_id failed for: #{object_id}")
    end
    
    def moving_parties
      @parties.select{|p|p.is_moving?}
    end
    
    ##############
    ### Humans ###
    ##############
    def load_human(user)
      @humans.each{|human|return human if human.user_id == user.id}
      human = Human.where(:user_id => user.id).first
      if (human != nil)
        add_human(human.modify)
        arm_publish('player/loaded', human)
      end
      human
    end
    
    def db_player_by_arg(arg)
      player_by_arg(Player.all.select{|player|
        p.user_id.nil? ?
          player.becomes(mob_factory.npc_klass_by_npc_id(player.npc_id)) :
          player.becomes(Human)
      })
    end

    def db_human_by_arg(arg)
      player_by_arg(Human.human, arg)
    end

    def db_players_by_arg(arg)
      players_by_arg(Human.human, arg)
    end
    
    def online_player_by_arg(arg)
      player_by_arg(@players, arg)
    end

    def online_players_by_arg(arg)
      players_by_arg(@players, arg)
    end
    
    def player_by_arg(players, arg)
      back = players_by_arg(players, arg)
      return back[0] unless back.count == 0
      nil
    end
    
    def player_by_list_arg(players, arg)
    end

    def players_by_list_arg(players, arg)
      return players[arg-1] if arg.integer?
      return players_by_arg(players, arg)
    end
    
    def players_by_arg(players, arg)
      # Test full name
      players.each do |player|
        return [player] if player.full_name == arg
      end
      # Test full name
      players.each do |player|
        return [player] if player.player_name == arg
      end
      back = []
      # Test full name
      players.each do |player|
        back.push(player) if player.full_name.start_with?(arg)
      end
      return back if back.count > 0
      # Test middle of name
      players.each do |player|
        back.push(player) if player.full_name.index(arg)
      end
      back
    end
    
    ############
    ### NPCs ###
    ############
    def add_human(player)
      bot.log.debug("PlayerFactory#add_human: #{player.display_name}")
      return player if @humans.include?(player)
      @humans.push(add_player(player))
      player.refresh_ricer_user
    end
    
    def add_player(player)
      @players.push(player)
      add_party(player.party)
      player.modify
    end
    
    def add_spawn(npc)
      if npc.is_mob?; add_mob(npc)
      elsif npc.is_real_npc?; add_realnpc(npc)
      elsif npc.is_stationary?; add_stationary(npc)
      elsif noc.is_human; raise StandardError.new("Human got called for add_spawn");
      else; raise StandardError.new("add_spawn NPC is none of the three kinds.")
      end
    end

    def add_npc(npc)
      npc.init_ai_scripts
      @npcs.push(npc)
      npc.npc_obj_id = @npcs.length
      add_player(npc)
    end
    
    def add_mob(npc)
      bot.log.debug("PlayerFactory#add_mob: #{npc.display_name}")
      @mobs.push(npc)
      add_npc(npc)
    end

    def add_stationary(npc)
      bot.log.debug("PlayerFactory#add_stationary: #{npc.display_name}")
      @stationary.push(npc)
      add_npc(npc)
    end
    
    def add_realnpc(npc)
      bot.log.debug("PlayerFactory#add_realnpc: #{npc.display_name}")
      @realnpc.push(npc)
      add_npc(npc)
    end
    ###### DEL
    def remove_human(player)
      @humans.delete(player)
      remove_player(player)
    end
    
    def remove_player(player)
      @players.delete(player)
      player
    end
    
    def remove_spawn(npc)
      if npc.is_mob?; remove_mob(npc)
      elsif npc.is_real_npc?; remove_realnpc(npc)
      elsif npc.is_stationary?; remove_stationary(npc)
      elsif noc.is_human; raise StandardError.new("Human got called for remove_spawn!");
      else; raise StandardError.new("remove_spawn NPC is none of the three kinds.")
      end
    end

    def remove_npc(npc)
      @npcs.delete(npc)
      remove_player(npc)
    end
    
    def remove_mob(npc)
      @mobs.delete(npc)
      remove_npc(npc)
    end

    def remove_stationary(npc)
      @stationary.delete(npc)
      remove_npc(npc)
    end
    
    def remove_realnpc(npc)
      @realnpc.delete(npc)
      remove_npc(npc)
    end
    
  end
end
