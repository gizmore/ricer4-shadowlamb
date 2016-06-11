module ActiveRecord::Magic::Param
  class SlNearEnemy < ShadowlambParam
    def input_to_value(input)
      player = Ricer4::User.current.instance_variable_get(:@sl5_player)
      failed_input unless player.is_fighting?
      Ricer4::Plugins::Shadowlamb::Core::PlayerFactory.
        player_by_list_arg(player.other_party.members, input) || failed_input
    end
  end
end
