module Ricer4::Plugins::Shadowlamb::Core
  class MobFactory
    
    #include Singleton
    
    include Include::Base
    include Include::Dice
    
    attr_reader :npc_classes, :npc_definitions
    
    ##############
    ### Loader ###
    ##############    
    def initialize
#      plugin_reload
    end
    
    def self.instance
      @instance ||= self.new
    end
    
    ### I18n
    def npc_path_i18n(npc_path)
      @npc_classes.each do |path, klass|
        return path if path.downcase.end_with?(npc_path.downcase)
      end
      npc_path
    end

    ### CACHE    
    def all_npcs; @npc_classes; end
    def npc_klass(npc_path); @npc_classes[npc_path] or raise UnknownNpc.new("Unknown npc_path: #{npc_path}"); end
    def npc_definition(npc_path); @npc_definitions[npc_path]; end
    def npc_klass_by_npc_id(npc_id); npc_klass NpcName.find(npc_id).npc_path; end
    def add_npc_class(npc_klass)
      npc_path = npc_klass.npc_path
      raise Ricer4::ConfigException.new("Duplicate add_npc_class mob/path: #{npc_path}") if @npc_classes[npc_path]
      @npc_classes[npc_path] = npc_klass
      @npc_ids[npc_path] = NpcName.register_npc(npc_path, npc_klass)
    end

    def add_mob_definition(npc_path, npc_definition, default_klass=Mob)
      add_npc_definition(npc_path, npc_definition, default_klass)
    end

    def add_real_npc_definition(npc_path, npc_definition, default_klass=RealNpc)
      add_npc_definition(npc_path, npc_definition, default_klass)
    end

    def add_stationary_definition(npc_path, npc_definition, default_klass=StationaryNpc)
      add_npc_definition(npc_path, npc_definition, default_klass)
    end

    def add_npc_definition(npc_path, npc_definition, default_klass)
      raise Ricer4::ConfigException.new("MobFactory#add_npc_definition has duplicate npc/path: #{npc_path}") unless @npc_definitions[npc_path].nil?
      @npc_classes[npc_path] ||= default_klass
      @npc_definitions[npc_path] = npc_definition
      NpcName.register_npc(npc_path, default_klass)
    end
    
    ###
    ### Hook some NPCs/Obstacles into their locations
    ### Has to be done after all is loaded.
    ###
    def after_loading_world_files
      @npc_classes.each do |npc_path,npc_klass|
        if npc_klass.instance_variable_defined?(:@sl5_stationary_location)
          location_guid = npc_klass.remove_instance_variable(:@sl5_stationary_location)
          action = npc_klass.remove_instance_variable(:@sl5_stationary_action)
          location = shadowverse.location_by_guid(location_guid)
          npc_klass.stationary_npc_at(location.lat, location.lon, location.floor, action)
        end
      end
    end
    
    ##############
    ### Reload ###
    ##############
    def plugin_reload
      @npc_classes, @npc_definitions, @npc_ids = {}, {}, {}
    end
    
    ###############
    ### Factory ###
    ###############
    # def spawn_mob(npc_path); npc = spawn_npc(npc_path); player_factory.add_mob(npc); npc; end
    # def spawn_real_npc(npc_path); npc = spawn_npc(npc_path); player_factory.add_real_npc(npc); npc; end
    # def spawn_stationary_npc(npc_path); npc = spawn_npc(npc_path); player_factory.add_stationary_npc(npc); npc; end
    def spawn_npc(npc_path)
      bot.log.debug("MobFactory#spawn_npc(#{npc_path})")
      npc_klass = npc_klass(npc_path)
      npc = npc_klass.new
      npc.npc_id = @npc_ids[npc_path]
      npc.build_player_values
      npc.sl5_npc_before_definition
      apply_npc_definition(npc, npc_path) unless @npc_definitions[npc_path].nil?
      npc.sl5_npc_after_definition
      npc.race = get_race(:human) if npc.race.nil?
      npc.gender = get_gender(:male) if npc.gender.nil?
      npc.playername = npc.random_name if npc.playername.nil?
      npc.modify.refresh.init_ai_scripts
    end
    
    def apply_npc_definition(npc, npc_path)
      begin
        apply_npc_definition!(npc, @npc_definitions[npc_path])
      rescue StandardError => e
        bot.log.error("ERROR IN #{npc_path} yml definition.")
        raise unless bot.genetic_rice
        bot.log.exception(e)
        nil
      end
      npc
    end
    
    #
    # Apply the yml definitions to a freshly spawned NPC.
    #
    def apply_npc_definition!(npc, definition)
   
      apply_npc_ai(npc, definition["ai"]||npc.default_ai_scripts)
      apply_npc_name(npc, definition["name"]||nil)

      apply_npc_race(npc, definition["race"])
      apply_npc_gender(npc, definition["gender"])
      apply_npc_professions(npc, definition["professions"])
      
      definition["base"].each do |key, value|; npc.levelup.set_base(key, dice_item_value(value)); end unless definition["base"].nil?
      definition["bonus"].each do |key, value|; npc.levelup.set_bonus(key, dice_item_value(value)); end unless definition["bonus"].nil?
      
      npc.cyberware.add_items(item_factory.create_inventory(definition["cyberware"]))
      npc.equipment.add_items(item_factory.create_equipment(definition["equipment"]))
      npc.inventory.add_items(item_factory.create_inventory(definition["inventory"]))
     
      npc
    end
    
    def apply_npc_ai(npc, scripts)
      Array(scripts).each do |ai_script|
        begin
          npc.exctend(get_ai(ai_script))
        rescue StandardError => e
          error = "Unknown ai script: #{ai_script} in yml."
          raise Ricer4::ConfigException.new error unless bot.genetic_rice
          bot.log.error(error)
        end
      end 
    end
    
    def apply_npc_name(npc, playername)
      npc.playername = playername
    end
    
    def apply_npc_race(npc, races)
      npc.race = get_race(dice_one_of(races)||'person')
    end

    def apply_npc_gender(npc, genders)
      npc.gender = get_gender(dice_one_of(genders)||'male')
    end

    def apply_npc_professions(npc, professions)
      professions = dice_multiple_of(professions) or return
      professions.each do |profession|
        npc.professions.push(get_profession(profession))
      end
    end

  end
end
