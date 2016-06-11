module Ricer4::Plugins::Shadowlamb::Core
  module Ai::HasAi
    def has_ai(options={}, &proc)
      class_eval do |klass|
        bot.log.debug("HasAi::has_ai:: #{options.inspect}")
        options[:proc] = proc if proc
        scripts = klass.instance_variable_defined?(:@sl5_ai_scripts) ?
          klass.instance_variable_get(:@sl5_ai_scripts) :
          klass.instance_variable_set(:@sl5_ai_scripts, [])
        scripts.push(options)
      end
    end
  end
  Npc.extend Ai::HasAi
end
