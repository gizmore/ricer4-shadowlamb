module ActiveRecord::Magic::Param
  class SlPlayer < ShadowlambParam
    def input_to_value(input)
      players = Ricer4::Plugins::Shadowlamb::Core::PlayerFactory.instance.db_players_by_arg(input)
      failed_input if players.count == 0
      fail('err_player_ambigious') if players.count >= 2
      players[0]
    end
  end
end
