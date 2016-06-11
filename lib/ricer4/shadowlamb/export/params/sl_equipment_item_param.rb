module ActiveRecord::Magic::Param
  class SlEquipmentItem < ShadowlambParam
    def input_to_value(input)
      player = Ricer4::User.current.instance_variable_get(:@sl5_player)
      player.equipped_i18n(input) || player.equipment.search_single_item(input)
    end
  end
end
