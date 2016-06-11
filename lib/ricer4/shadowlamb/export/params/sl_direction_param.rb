module ActiveRecord::Magic::Param
  class SlDirection < ShadowlambParam
    def input_to_value(input)
      Ricer4::Plugins::Shadowlamb::Core::Direction.parse(input) rescue nil
    end
  end
end
