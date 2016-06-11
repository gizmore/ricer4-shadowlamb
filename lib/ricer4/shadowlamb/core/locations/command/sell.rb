module Ricer4::Plugins::Shadowlamb
  class Sell < Core::Command

    trigger_is :sell
    
    requires_player

    def enabled?
      party.inside_location_provides?(:sell)
    end

    has_usage '<sl_inventory_item>'
    def execute(items)
      return unless shop_wants_items?(items)
      
      
      
    end
    
    def shop_wants_items?(items)
      unwanted = []
      items.each do |item|
        unwanted.push(item) unless shop_wants_item?(item)
      end
      rply :err_dont_want, items: join(unwanted.collect{|item|item.display_name}) unless unwanted.empty?
      unwanted.empty?
    end
    
    def shop_wants_item?(item)
      item.sellable? && player.location.sl5_wants_item?(item)
    end
    
  end
end
