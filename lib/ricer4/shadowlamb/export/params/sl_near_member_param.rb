module ActiveRecord::Magic::Param
  class SlNearMember < ShadowlambParam
    def input_to_value(input)
      player = own_player
      player_factory.player_by_list_arg(player.party.members, input) || failed_input
    end
  end
end
