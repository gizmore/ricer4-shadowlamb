module Ricer4::Plugins::Shadowlamb::Core::Extend::Obstacle

  def is_obstacle_on(lat1, lon1, lat2, lon2, obstacle_action=:inside)
    class_eval do |klass|
#      klass.instance_variable_set(:@sl5_obstacle_action, obstacle_action.to_s)
      klass.has_coordinates(lat1, lon1, lat2, lon2)
      shadowverse.add_obstacle(klass.new(obstacle_action))
    end
  end

  def is_obstacle_at(lat, lon, radius=1, obstacle_action=:inside)
    class_eval do |klass|
      klass.is_obstacle_on(lat-radius, lon-radius, lat+radius, lon+radius)
    end
  end

  def is_obstacle_in(location, radius=1, obstacle_action=:inside)
    class_eval do |klass|
      klass.is_obstacle_at(location.lat, location.lon, radius, obstacle_action)
    end
  end

  def is_obstacle_inside(location, radius=1)
    class_eval do |klass|
      klass.is_obstacle_in(location, radius, :inside)
    end
  end

  def is_obstacle_outside(location, radius=1)
    class_eval do |klass|
      klass.is_obstacle_in(location, radius, :outside)
    end
  end
  
end
