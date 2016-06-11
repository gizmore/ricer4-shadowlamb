module Ricer4::Plugins::Shadowlamb::Core::Extend::IsStaticItem
  
  def is_static_item
    class_eval do |klass|
      def owner; @owner; end
      def owner=(owner); @owner = owner; end
    end
  end

end
