module ActiveRecord::Magic::Param
  class SlRace < ShadowlambParam
    
    def input_to_value(input)
      race = Ricer4::Plugins::Shadowlamb::Core::Race.get_race(input)
      return nil unless race && race.human?
      race
    end
    
    def value_to_input(race)
      race.name rescue nil
    end

  end
end
