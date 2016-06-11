module Ricer4::Plugins::Shadowlamb::Core
  module Locations::ExtendExit

    def open_area
      class_eval do |klass|
        def sl5_can_exit_area?(party, old_area, new_area); true; end
        def sl5_can_enter_area?(party, old_area, new_area); true; end
      end
    end
    
    def closed_area
      class_eval do |klass|
        klass.instance_variable_set(:@sl5_closed_area, true)
        def sl5_can_exit_area?(party, old_area, new_area); old_area.overlaps?(new_area); end
        def sl5_can_enter_area?(party, old_area, new_area); new_area.overlaps?(old_area); end
      end
    end
    
    def is_locked()
      class_eval do |klass|
      end
    end
    
    def is_entrance_for(area_path)
      class_eval do |klass|
        arm_subscribe('world/loaded') do
          area = shadowverse.get_area(area_path) or raise Ricer4::ConfigException.new("Unknown area for entrance #{klass.name}")
          location = shadowverse.get_location(klass.guid) or raise Ricer4::ConfigException.new("Unknown location for entrance #{klass.name}")
          area.add_location(location)
        end
      end
    end
  end
  
  Area.extend Locations::ExtendExit
end
