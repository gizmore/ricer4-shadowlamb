module Ricer4::Plugins::Shadowlamb::Core
  class ValueType::Bodyhp < ValueType::Attribute

    rune_fits_in Items::Amulet, :match => 100, :max => 3, :price => 800 
    rune_fits_in Items::Boots,  :match =>  20, :max => 2, :price => 500
    rune_fits_in Items::Belt,   :match =>  20, :max => 1, :price => 400
    
    craft_looting Items::Ring,    :chance => 20, :max => 1
    craft_looting Items::Earring, :chance => 10, :max => 1
    
#    def install_data_set
#      get_shadowlamb_plugin.class.has_setting({
#        name: :bodyhp, scope: :bot, permission: :responsible, type: :integer, min: 0, max: 128, default: 10
#      })
#    end
    
#    def default
#      get_config(:bodyhp)
#    end

  end
end
