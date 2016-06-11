module Ricer4::Plugins::Shadowlamb::Core::Extend::RequiresPlayer
  def requires_player(boolean=true)
    class_eval do |klass|
      if boolean
        klass.register_exec_function(:execute_requires_player!)
        def execute_requires_player!(line)
          player = self.player
          raise Ricer4::Plugins::Shadowlamb::Core::NotStarted.new if player.nil?
          player.refresh_ricer_user unless sender.instance_variable_defined?(:@sl5_player)
        end
      else
        klass.register_exec_function(:execute_requires_guest!)
        def execute_requires_guest!(line)
          raise Ricer4::ExecutionException.new(t(:err_reset_first)) unless player.nil? 
        end
      end
    end
  end
end
