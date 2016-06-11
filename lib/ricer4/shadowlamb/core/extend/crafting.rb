module Ricer4::Plugins::Shadowlamb::Core::Extend::Crafting
  ### ValueName types attach extender ###
  ### Use only in ValueNames/Types   ###
  #####################################
  # Simply attach value_name and options to the mount/item classes etc
  def rune_fits_in(klass, options)
    options.reverse_merge!({match:100, price:100, max:100, fail:100, ruin:100})
    class_eval do |value_name_klass|
      craft_options = klass.instance_variable_defined?(:@sl5_craft_options) ?
        klass.instance_variable_get(:@sl5_craft_options) :
        klass.instance_variable_set(:@sl5_craft_options, {})
      craft_options[value_name_klass] = options
    end
  end
  
  # Simply attach value_name and options to the mount/item classes etc
  def craft_looting(klass, options)
    options.reverse_merge!({chance:100, max:100})
    class_eval do |value_name_klass|
      craft_options = klass.instance_variable_defined?(:@sl5_craft_loot) ?
        klass.instance_variable_get(:@sl5_craft_loot) :
        klass.instance_variable_set(:@sl5_craft_loot, {})
      craft_options[value_name_klass] = options
    end
  end
  
  ### Dicing
end
