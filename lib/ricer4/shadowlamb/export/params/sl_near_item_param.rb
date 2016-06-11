module ActiveRecord::Magic::Param
  class SlNearItem < ShadowlambParam
    def input_to_value(input)
      failed_input
    end
  end
end
