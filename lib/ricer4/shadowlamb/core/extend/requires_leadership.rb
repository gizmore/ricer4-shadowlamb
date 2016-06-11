module Ricer4::Plugins::Shadowlamb::Core::Extend::RequiresLeadership
  def requires_leadership()
    class_eval do |klass|
      klass.requires_player
      klass.register_exec_function(:execute_requires_leadership!)
      def execute_requires_leadership!(line)
        raise Ricer4::ExecutionException.new(t('err_requires_leadership')) unless player.is_leader?
      end
    end
  end
end
