module Ricer4::Plugins::Shadowlamb
  class Cast < Core::Command
    
    is_combat_trigger :cast
    
    works_always
    
    has_usage  '<sl_spell> <sl_near_player>', function: :_execute_cast
    has_usage  '<sl_spell>', function: :_execute_cast

    def _execute_cast(spell, target=nil)
      execute_cast(player, spell, target||player)
    end
    
    def execute_cast(caster, spell, target)
      combat_command(caster) do
        begin
          spell.cast!(caster, target)
        ensure
          caster.busy(spell.cast_time)
        end
      end
    end
    
  end
end
