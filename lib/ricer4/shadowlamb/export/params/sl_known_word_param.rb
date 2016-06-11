module ActiveRecord::Magic::Param
  class SlKnownWord < ShadowlambParam
    
    def input_to_value(input)
      Ricer4::Plugins::Shadowlamb::Core::Word.find_or_initialize_by(:name => input)
    end
    
  end
end
