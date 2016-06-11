load File.expand_path("../race.rb", __FILE__)
module Ricer4::Plugins::Shadowlamb::Core
  class NpcRace < Race
      
    def self.human?; false; end

  end
end
