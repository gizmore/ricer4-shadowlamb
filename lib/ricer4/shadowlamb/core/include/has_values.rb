module Ricer4::Plugins::Shadowlamb::Core
  module Include::HasValues
  
    ########################
    ### Can´t touch this ###
    ########################
    def self.included(base)
      if base.respond_to?(:dont_store_values)
        base.has_many :values, :class_name => 'Ricer4::Plugins::Shadowlamb::Core::Value', as: :owner, :autosave => false
      else
        base.has_many :values, :class_name => 'Ricer4::Plugins::Shadowlamb::Core::Value', as: :owner, :autosave => true
      end
    end
    
#    def get_value_name(key)
#      Ricer4::Plugins::Shadowlamb::Core::ValueName.get_value_name(key)
#    end
    
    def get_value_from_memory(key)
      value_name_id = get_value_name(key).id rescue nil
      raise Ricer4::ConfigException.new("Unkown value key: #{key}") unless value_name_id
      values.each do |v|
        if v.value_name_id == value_name_id
          return v
        end
      end
      nil
    end
    
    def get_value(key)
      get_value_from_memory(key) || values.new(:value_name => get_value_name(key))
    end

    #################
    ### Use these ###
    #################
    def get_base_raw(key)
      get_value(key).base_value
    end

    def get_bonus_raw(key)
      get_value(key).bonus_value
    end
    
    def get_base(key)
      get_base_clamped(key)
    end

    def get_bonus(key)
      get_bonus_clamped(key)
    end
    
    def get_adjusted(key)
      get_adjusted_clamped(key)
    end


    def get_base_clamped(key, min=0, max=nil)
      clamp(get_base_raw(key), min, max)
    end

    def get_bonus_clamped(key, min=0, max=nil)
      clamp(get_bonus_raw(key), min, max)
    end

    def get_adjusted_clamped(key, min=0, max=nil)
      clamp(get_base_clamped(key)+get_bonus_clamped(key), min, max)
    end

    
    def set_base(key, value)
      get_value(key).base_value = value
      value
    end

    def set_bonus(key, value)
      get_value(key).bonus_value = value
      value
    end

    def set_base_clamped(key, value, min=0, max=nil)
      get_value(key).base_value = clamp(value, min, max)
      value
    end

    def set_bonus_clamped(key, value, min=0, max=nil)
      get_value(key).bonus_value = clamp(value, min, max)
      value
    end


    def save_base(key, value)
      val = get_value(key)
      val.base_value = value
      val.save!
    end
    
    def save_bonus(key, value)
      val = get_value(key)
      val.bonus_value = value
      val.save!
    end

    
    def add_base(key, value)
      value = get_base_raw(key) + value
      set_base(key, value)
    end

    def add_base_clamped(key, value, min=0, max=nil)
      value = clamp(get_base_raw(key)+value, min, max)
      set_base(key, value)
    end
    
    def add_bonus(key, value)
      value = get_bonus_raw(key) + value
      set_bonus(key, value)
    end

    def add_bonus_clamped(key, value, min=0, max=nil)
      value = clamp(get_bonus_raw(key)+value, min, max)
      set_bonus(key, value)
    end


    def clamp_base(key, min=nil, max=nil)
      clamp(get_base(key), min, max)
    end

    def clamp_bonus(key, min=nil, max=nil)
      clamp(get_bonus(key), min, max)
    end

  end
end
