module Ricer4::Plugins::Shadowlamb::Core::Locations::ExtendCanSleepHere
  def can_sleep_here()
    class_eval do |klass|
      klass.add_shadowlamb_command(:sleep)
    end
  end
end
