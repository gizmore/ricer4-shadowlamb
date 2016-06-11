module Ricer4::Plugins::Shadowlamb::Core
  class ValueType::MaxHp < ValueType::Combat

    def apply_to(player, adjusted)
      body = player.get_adjusted(:body)
      body_hp = player.get_adjusted(:bodyhp)
      player.add_bonus(:max_hp, body * body_hp)
    end

  end
end
