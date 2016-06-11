module Ricer4::Plugins::Shadowlamb::Core
  module Ai::IsMob
    def is_mob
      class_eval do |klass|
        klass.has_algorithm('mob')
        MobFactory.instance.add_npc_class(klass)
      end
    end
  end
  Npc.extend Ai::IsMob
end
