module Ricer4::Plugins::Shadowlamb::Core::Extend::WorksWhenIdle
  def works_when_idle()
    class_eval do |klass|
      klass.works_when :inside, :outside
    end
  end
end
