module Ricer4::Plugins::Shadowlamb::Core::Locations::ExtendRespawnHere
  def respawn_here()
    class_eval do |klass|
      shadowverse.add_respawn_location(klass)
    end
  end
end
