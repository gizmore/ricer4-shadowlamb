module Ricer4::Plugins::Shadowlamb
  module Core::Include
    module Translates

      def tkey(key)
        key.is_a?(Symbol) ? "shadowlamb.#{key}" : key
      end

      def t!(key, args={})
        I18n.t!(tkey(key), args)
      end
      
      def t(key, args={})
        tt(tkey(key), args)
      end
      
      def tt(key, args)
        begin
          I18n.t!(key, args)
        rescue StandardError => e
          bot.log.exception(e)
          "#{key}: #{args.inspect}"
        end
      end
      
    end
  end
end
