load File.expand_path("../../core/area.rb", __FILE__)
module Ricer4::Plugins::Shadowlamb
  class World::World < Core::Area
    
    has_area(-90.0, -180.0, 90.0, 180.0)

    def is_world?; true; end
    
    # arm_subscribe('party/loaded') do |sender, party|
      # self.reset_party_position
      # if party.area.is_world?
        # area.child_areas.each
        # byebug
      # end
    # end

  end
end
