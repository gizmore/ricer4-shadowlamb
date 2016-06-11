module Ricer4::Plugins::Shadowlamb::Core::Extend::IsQuest
  
  def guid; class_eval{|klass|klass.name.substr_from('World::')}; end
  
  

  def is_quest
    class_eval do |klass|
      shadowverse.add_quest(klass)
    end
  end
  
  def bring(options={})
    class_eval do |klass|
      klass.is_quest
    end
  end

  

end
