module ActiveRecord::Magic::Param
  class SlItemName < ShadowlambParam
    def input_to_value(input)
      Ricer4::Plugins::Shadowlamb::Core::ItemFactory.instance.from_gmi(input) || failed_input
    end
  end
end
