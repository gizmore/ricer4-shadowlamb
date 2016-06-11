module ActiveRecord::Magic::Param
  class SlDistance < ShadowlambParam
    def input_to_value(input)
      input.to_i rescue failed_input
    end
  end
end
