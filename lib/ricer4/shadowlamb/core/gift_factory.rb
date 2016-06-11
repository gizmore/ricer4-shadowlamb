module Ricer4::Plugins::Shadowlamb::Core
  class GiftFactory
    
#    include Singleton
    def self.instance; @instance ||= self.new; end
    
    
    include Include::Base
    include Include::Dice
    include Include::KnowsItems
    
    def random_item(min_level=0, max_level=nil, power=100)
      ItemName.all_item_names.each do |item_name_klass|
        
        
        
      end
    end
    
  end
end
