module Ricer4::Plugins::Shadowlamb::Core
  module Ai::IsRealNpc
    def is_real_npc
      class_eval do |klass|
        klass.has_algorithm('real_npc')
        MobFactory.instance.add_npc_class(klass)
      end
    end
  end
  Npc.extend Ai::IsRealNpc
end
