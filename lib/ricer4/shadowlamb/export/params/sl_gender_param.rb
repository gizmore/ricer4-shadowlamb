module ActiveRecord::Magic::Param
  class SlGender < ShadowlambParam

    def input_to_value(input)
      Ricer4::Plugins::Shadowlamb::Core::Gender.get_gender(input)
    end
    
    def value_to_input(gender)
      gender.name rescue nil
    end

  end
end
