module Ricer4::Extend::IsCombatTrigger
  def is_combat_trigger(trigger)
    class_eval do |klass|
      klass.trigger_is trigger
      klass.requires_player
      def combat_command(player, lock=false, &block)
        if player.is_fighting?
          player.combat_command = block
          player.combat_command_lock = lock
        else
          yield block
        end
      end
    end
  end
end

