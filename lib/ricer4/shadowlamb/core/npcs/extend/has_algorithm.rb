module Ricer4::Plugins::Shadowlamb::Core
  module Ai::HasAlgorithm
    def has_algorithm(*ai_scripts)
      return if ai_scripts.empty?
      class_eval do |klass|
        ai_scripts.each do |ai_script|
          scripts = ai_script.to_s.split(',') if ai_script.is_a?(String) || ai_script.is_a?(Symbol)
          scripts.each do |script|
#            ai_klass = klass.get_ai(script.to_s)
          end
        end
      end
    end
  end
  Npc.extend Ai::HasAlgorithm
end
