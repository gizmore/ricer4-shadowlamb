module Ricer4::Plugins::Shadowlamb
  class Quests < Core::Command

    requires_player

    is_list_trigger "sr.quests", :for => true, :search_pattern => '<string|named:"search_term">', :per_page => 10

    def all_visible_relation
      player.missions
    end
    
    def search_class_name
      t(:quest)
    end

  end
end
