module Ricer4::Plugins::Shadowlamb::Core
  class Obstacle
  
    include Include::Base
    include Include::Guid
    include Include::Dice
    include Include::Translates
    include Include::HasLocation
    include Include::Obstacle
    
    def initialize(action=:inside)
      @action = action
    end
    
  end
end
