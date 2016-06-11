module Ricer4::Plugins::Shadowlamb::Core::Extend::WorksWhenAlone
  def works_when_alone
    class_eval do |klass|
      klass.register_exec_function(:execute_works_when_alone!)
      def execute_works_when_alone!(line)
        raise Ricer4::Plugins::Shadowlamb::Core::NotStarted.new if player.nil?
        raise Ricer4::ExecutionException.new(t(:err_not_alone)) if player.party.membercount > 1
      end
    end
  end
end
