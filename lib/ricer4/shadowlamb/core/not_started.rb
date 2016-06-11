module Ricer4::Plugins::Shadowlamb::Core
  class NotStarted < Ricer4::ExecutionException
    def initialize
      super(exception_texts)
    end
    def exception_texts
      I18n.t!('shadowlamb.err_not_started') rescue 'You need to #start first.'
    end
  end
end
