module Ricer4::Plugins::Shadowlamb::Core
  class ValueType::MaxMp < ValueType::Combat

    def apply_to(player, adjusted)
      magic = player.get_adjusted(:magic)
      magic_mp = player.get_adjusted(:magicmp)
      player.add_bonus(:max_mp, magic * magic_mp)
    end

  end
end
