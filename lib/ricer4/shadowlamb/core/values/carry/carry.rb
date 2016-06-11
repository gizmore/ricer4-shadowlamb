module Ricer4::Plugins::Shadowlamb::Core
  class ValueType::Carry < ValueType::Combat
  
    def install_data_set
      get_shadowlamb_plugin.class.has_setting({
        name: :basecarry,     scope: :bot, permission: :responsible, type: :integer, min: 100, max: 100000, default: 5000
      })
      get_shadowlamb_plugin.class.has_setting({
        name: :strengthcarry, scope: :bot, permission: :responsible, type: :integer, min: 100, max: 100000, default: 1500
      })
    end
    def basecarry; get_config(:basecarry); end
    def strengthcarry; get_config(:strengthcarry); end

    def carry_load(player)
      (player.get_base(:carry) / player.get_bonus(:carry) * 10000).to_i
    end

    def apply_to(player, adjusted)
      # max_carry
      strength = player.get_adjusted(:strength)
      player.add_bonus(:carry, ((strength * strengthcarry) + basecarry))
      # carrying
      apply_weight_to(player, player.equipment, player.inventory)
    end
    
    def apply_weight_to(player, *item_lists)
      item_lists.each do |item_list|
        item_list.items.each do |item|
          player.add_base(:carry, item.get_adjusted(:weight))
        end
      end
    end
    
    def display_carry_status(player)
      t(:carry_status, carries: player.get_base(:carry), max_carry: player.get_bonus(:carry))
    end

  end
end
