module Ricer4::Plugins::Shadowlamb
  class WorldCmd < Core::Command
    
    trigger_is :world
    
    has_usage '', function: :execute_world

    def execute_world
      factory = player_factory
      rply(:msg_world,
        values: Ricer4::Plugins::Shadowlamb::Core::ValueName.all_values.count,
        races: Ricer4::Plugins::Shadowlamb::Core::Race.all_races.count,
        genders: Ricer4::Plugins::Shadowlamb::Core::Gender.all_genders.count,
        spells: Ricer4::Plugins::Shadowlamb::Core::Spell.all_spells.count,
        items:  Ricer4::Plugins::Shadowlamb::Core::ItemName.all_item_names.count,
        cities: shadowverse.cities.count,
        dungeons: shadowverse.dungeons.count,
        locations: shadowverse.locations.count,
        obstacles: 2,
        npcs: mob_factory.all_npcs.count,
#        quests: quest_factory.all_quests.count,
        quests: 2,
        codesize: human_filesize(codesize),
      )
    end

    def codesize
      @codesize ||= _codesize
    end
    
    def _codesize
      bytes = 0
      Filewalker.traverse_files(shadowlamb_dir) do |path|
        bytes += File.size(path) unless path.end_with?('.json')
      end
      bytes
    end
      
  end
end
