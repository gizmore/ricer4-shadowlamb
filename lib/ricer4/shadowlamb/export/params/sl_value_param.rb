module ActiveRecord::Magic::Param
  class SlValue < ShadowlambParam
    def input_to_value(input)
      Ricer4::Plugins::Shadowlamb::Core::ValueName.get_value_name_i18n(input) || failed_input
    end
  end
end
