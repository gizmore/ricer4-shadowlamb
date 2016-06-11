module Ricer4::Plugins::Shadowlamb::Core::Include::HasRequirements

  def meets_requirements?(player)
    true
  end
  
  def check_requirements!(player)
    requirement_error!(player, self) unless meets_requirements?(player)
  end
      
  def requirement_error!(player, item)
    raise Ricer4::ExecutionException.new(requirement_error_message(player, item))
  end

  def requirement_error_message(player, item)
    out, red, green = [], lib.red, lib.green
    item.requirements.each do |k, v|
      color = player.get_base(k) < v ? red : green
      out.push("#{get_value_name(k).long_label}: #{color}#{v}#{color}(#{player.base_value})")
    end
    tt('shadowlamb.err_requirements', requirements: values_join(out))
  end
  
end
