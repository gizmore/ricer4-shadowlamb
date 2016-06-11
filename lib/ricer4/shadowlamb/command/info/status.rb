module Ricer4::Plugins::Shadowlamb
  class Status < Core::Command
    
    trigger_is :status
    
    requires_player

    has_usage '', function: :_execute_status
    
    def _execute_status
      execute_status(player)
    end
    
    SPECIAL_VALUES = [:hp, :max_hp, :mp, :max_mp, :carry, :level]

    def execute_status(player)
      
      out = []
      player.values.each do |value|
        if value.section_is?(:combat) && (!SPECIAL_VALUES.include?(value.value_key.to_sym))
          out.push("#{value.to_label}: #{value.base_value}(#{value.adjusted_value})")
        end
      end
      rply :msg_status,
        player: player.display_name,
        gender: player.gender.to_label,
        race: player.race.to_label,
        title: player.display_title,
        level: player.get_base(:level),
        adjustlevel: player.get_adjusted(:level),
        nuyen: player.nuyen,
        carrystatus: get_value_name(:carry).display_carry_status(player),
        hpstatus: player.display_hp,
        mpstatus: player.display_mp,
        xp: player.xp,
        karma: player.karma,
        combat_values: values_join(out)
    end
      
  end
end
