module Ricer4::Plugins::Shadowlamb::Core
  module Ai::IsStationaryNpc
    
    def stationary_npc_at(lat, lon, floor=0, action=:inside)
      class_eval do |klass|
        klass.has_algorithm :stationary
        klass.instance_variable_set(:@sl5_stationary_lat, lat)
        klass.instance_variable_set(:@sl5_stationary_lon, lon)
        klass.instance_variable_set(:@sl5_stationary_action, action)
        def stationary_lat; self.class.instance_variable_get(:@sl5_stationary_lat); end
        def stationary_lon; self.class.instance_variable_get(:@sl5_stationary_lon); end
        def stationary_action; self.class.instance_variable_get(:@sl5_stationary_action); end
      end
    end

    def stationary_npc_in(location_guid, action=:inside)
      class_eval do |klass|
        klass.instance_variable_set(:@sl5_stationary_action, action)
        klass.instance_variable_set(:@sl5_stationary_location, location_guid)
        klass.mob_factory.add_npc_class(klass)
      end
    end

    def stationary_npc_inside(location_guid)
      class_eval do |klass|
        klass.stationary_npc_in(location_guid, :inside)
      end
    end

    def stationary_npc_outside(location_guid)
      class_eval do |klass|
        klass.stationary_npc_in(location_guid, :outside)
      end
    end

  end

  Npc.extend Ai::IsStationaryNpc
end
