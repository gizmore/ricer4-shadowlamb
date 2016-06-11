module ActiveRecord::Magic::Param
  class SlCoordinate < ShadowlambParam
    def input_to_value(input)
      Ricer4::Plugins::Shadowlamb::Core::Coordinate.parse!(input) rescue nil
    end
  end
end
