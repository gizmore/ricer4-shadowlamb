module Ricer4::Plugins::Shadowlamb::Core::Include::Every
  
  def every(interval, object=nil, &block)

    object ||= self
    every_key = block.source_location.join
    every_stamps = object.instance_variable_defined?(:@last_every) ? object.instance_variable_get(:@last_every) : object.instance_variable_set(:@last_every, {})
    
    time = shadowtime
    last = every_stamps[every_key] ||= time
    elapsed = last - time
    
    if elapsed >= interval
      every_stamps[every_key] = last + interval
      yield block
    end
    
  end
  
end