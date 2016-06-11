module Ricer4::Plugins::Shadowlamb::Core::Locations::ExtendShop
  
  DEFAULT_SHOP_CONFIG ||= {
    max_discount_percent: 0.20,
    max_sell_negotiation: 0.10,
  }
  
  def is_shop(config={})
    class_eval do |klass|
      
      klass.instance_variable_set(:@sl5_shop_config, config.reverse_merge(DEFAULT_SHOP_CONFIG))

      klass.instance_variable_set(:@sl5_shop_items, [])
      
      def sl5_shop_config(key); self.class.instance_variable_get(:@sl5_shop_config)[key]; end
      
      def sl5_shop_max_discount(); sl5_shop_config(:max_discount_percent); end
      def sl5_shop_max_sell_nego(); sl5_shop_config(:max_sell_negotiation); end
      def sl5_wants_item?(item); true; end
      
    end
  end
  
  def buys_items
    class_eval do |klass|

      klass.add_shadowlamb_command(:buy)
      
    end
  end
  
  def sells_items(*item_datas)
    class_eval do |klass|
      item_datas.each do |item_data|
        sells_item(item_data)
      end
    end
  end

  def sells_item(item_data=nil, &block)
    class_eval do |klass|
      
      item_factory.validate_shop_item_hash!(item_data) unless item_data.is_a?(Proc)
      
      klass.add_shadowlamb_command(:sell)
      klass.add_shadowlamb_command(:view)
      klass.add_shadowlamb_command(:viewi)
      
      items = klass.instance_variable_get(:@sl5_shop_items)
      items.push(item_data) if item_data
      items.push(&block) if block_given?
      
      def sl5_shop_item_data
        self.class.instance_variable_get(:@sl5_shop_items)
      end
      
      def sl5_shop_items(player)
        @items = []
        sl5_shop_item_data.each do |item_data|
          if item = sl5_shop_item(player, item_data)
            @items.push(item)
          end
        end
        @items
      end
      
      def sl5_shop_item(player, item_data)
        item_data = item_data.call(player) unless item_data.is_a?(Hash)
        return nil unless item_data
        item_data.reverse_merge!(sl5_default_shop_item_data)
        return nil unless sl5_shop_item_available?(player, item_data)
        item_factory.from_shop_data(item_data)
      end
      
      def sl5_shop_item_available?(player, item_data)
        true
      end
      
      def sl5_default_shop_item_data
        { name: nil, amount: 1, price: nil, negotiate: true, chance: 100 }
      end

      def sl5_get_shop_items(player)
        sl5_shop_items(player)
      end

    end
  end
end
