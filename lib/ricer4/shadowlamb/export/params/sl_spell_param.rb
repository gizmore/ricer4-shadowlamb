module ActiveRecord::Magic::Param
  class SlSpell < ShadowlambParam
    def input_to_value(input)
      player = Ricer4::User.current.instance_variable_get(:@sl5_player)
      failed_input
    end
  end
end
