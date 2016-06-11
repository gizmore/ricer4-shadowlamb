module ActiveRecord::Magic::Param
  class SlItem < ShadowlambParam
    def input_to_value(input)
      failed_input
    end
  end
end
