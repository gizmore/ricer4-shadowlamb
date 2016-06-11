module ActiveRecord::Magic::Param
  class SlObstacle < ShadowlambParam
    def input_to_value(input)
      Ricer4::PLugins::Shadowlamb::Core::Shadowverse.instance.obstacle_by_arg(input) || failed_input
    end
  end
end
