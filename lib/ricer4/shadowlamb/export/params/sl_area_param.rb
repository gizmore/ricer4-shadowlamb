module ActiveRecord::Magic::Param
  class SlArea < ShadowlambParam
    
    def input_to_value(input)
      shadowverse.areas.each do |area|
        return area if area.display_name == input
      end
      nil
    end
    
    def value_to_input(area)
      area.id rescue nil
    end

  end
end
