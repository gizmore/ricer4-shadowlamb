module Ricer4::Plugins::Shadowlamb::Core::Extend::WorksWhen

  def works_when(*actions)
    class_eval do |klass|

      klass.requires_player
      # Sanitize
      # FIXME: Action.valid? is not working yet, when we use this extender. 
      # actions.each do |action|
        # unless Ricer4::Plugins::Shadowlamb::Core::Action.valid?(action)
          # throw Exception.new("#{klass.name} works_in invalid actions: #{actions.inspect}. THIS ACTION: #{action.inspect}")
        # end
      # end
    
      # Append to works_in data
      #klass.register_class_variable(:@sl5_work_in_actions)
      works_in = klass.define_class_variable(:@sl5_work_in_actions, [])
      works_in.concat(actions)
      
      # Hook to exec
      klass.register_exec_function(:execute_works_when!)
      
      private

      def execute_works_when!(line)
        unless command_works_in?(party.action)
          raise Ricer4::ExecutionException.new(tt('shadowlamb.err_wrong_action', current_action: party.display_action))
        end
      end
      
      def command_works_in?(action)
        allowed_command_actions.include?(action.name.to_sym)
      end
      
      def allowed_command_actions
        get_class_variable(:@sl5_work_in_actions)
      end
      
    end
  end
  
  # def doesnt_work_when(*actions)
    # class_eval do |klass|
      # return unless klass.define_class_variable(:@sl5_work_in_actions, [])
      # works_in -= actions
    # end
  # end

  def works_always
    class_eval do |klass|
      klass.works_always_except
    end
  end

  def works_always_except(*except)
    class_eval do |klass|
      always = [:fighting, :talking, :inside, :outside, :knocking, :goto, :move, :explore, :travel]
      klass.works_when(always - except)
    end
  end
  
end
    
