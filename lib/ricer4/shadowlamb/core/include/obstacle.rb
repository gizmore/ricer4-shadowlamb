module Ricer4::Plugins::Shadowlamb::Core::Include::Obstacle

  def self.included(base)
    base.extend(Ricer4::Plugins::Shadowlamb::Core::Extend::Obstacle)
  end

  def obstacle_action
    self.class.instance_variable_get(:@sl5_obstacle_action)
  end
  
  def sees?(party)
    (party.location == self.location) &&
    (party.action.name == self.obstacle_action)
  end
  
  def area; @area ||= shadowverse.locate_area(self); end
  def location; @location ||= shadowverse.locate_location(self); end

  def sl5_on_using_with(player, object)
    sl5_on_being_used(player, object)
  end
  
  def sl5_on_being_used(player, object)
  end
  
end
