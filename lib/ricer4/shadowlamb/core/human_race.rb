load File.expand_path("../race.rb", __FILE__)
module Ricer4::Plugins::Shadowlamb::Core
  class HumanRace < Race
      
    def self.human?; true; end
    
    arm_events
    include Include::SpawnsItems
    
    def sl5_player_created(player)
      data_file = get_data_file(:races)
      name_string = player.race.name_string
      data_file["inventory"][name_string].each do |item_name|
        player.inventory.add_item(get_item_gmi(item_name))
      end
      data_file["equipment"][name_string].each do |item_name|
        player.equipment.add_item(get_item_gmi(item_name))
      end
      player.modify
    end

  end
end
