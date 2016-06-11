module ActiveRecord::Magic::Param
  class Amount < ActiveRecord::Magic::Param::Integer
    
    def default_options; { min: 1, max: nil, default: 1 }; end

  end
end
