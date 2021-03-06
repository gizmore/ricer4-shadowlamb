module ActiveRecord::Magic::Param
  class SlNearPlayer < ShadowlambParam
    def input_to_value(input)
      players = own_party.near_players(input)
      failed_input if players.count == 0
      fail('err_player_ambigious') if players.count >= 2
      players[0]
    end
  end
end
