module Ricer4::Plugins::Shadowlamb::Core::Extend::HasRequirements
  def has_requirements(requirements={})
    class_eval do |klass|

      raise StandardError.new("Extend::HasRequirements: requirements is not a hash!") unless requirements.is_a?(Hash)

      klass.instance_variable_set(:@sl5_requirements, requirements)

      def requirements
        self.class.instance_variable_get(:@sl5_requirements)
      end
      
      def meets_requirements?(player)
        missing_requirements(player).empty?
      end
      
      def missing_requirements(player)
        requirements.collect{|key,value|player.get_base_value(key)<value.adjusted_value}
      end

      def display_requirements(player)
        out = requirements.collect do |key,value|
          color = player.get_base_value(key) >= value.adjusted_value ? lib.dark_green : lib.light_red
          "#{color}#{value.short_label}: #{value.adjusted_value}#{color}"
        end
        value_join(out)
      end
      
      def check_requirements!(player)
        requires = requirements_missing(player)
        unless requires.empty?
          raise StandardError.new(t(:err_requirements,
            object: self.display_name,
            error: requirements_error(player, requires),
            requires: requires,
          ))
        end
      end
      
      def requirements_error(player, requires)
        human_join(requires.collect{|key,value|"#{value.short_label}: #{value.adjusted_value}"})
      end

    end
  end
end
