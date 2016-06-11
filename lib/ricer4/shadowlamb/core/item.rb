module Ricer4::Plugins::Shadowlamb::Core
  class Item < ActiveRecord::Base
    
    self.table_name = 'sl5_items'

    include Include::Base
    include Include::Dice
    include Include::Translates
    include Include::Damage
    include Include::HasValues
    include Include::HasRequirements
    extend   Extend::HasRequirements
    
    attr_reader :selected_amount
    
    belongs_to :item_name, :class_name => "Ricer4::Plugins::Shadowlamb::Core::ItemName"
    belongs_to :item_list, :class_name => "Ricer4::Plugins::Shadowlamb::Core::ItemList" #, :autosave => false
    
    def owner; item_list.owner; end

    def item_klass; @item_klass ||= item_name.item_klass; end
    def item_object; @item_object ||= self.becomes(item_klass); end

    delegate :equipment_slot, :equipment_slot_short, :equipment_slot_long,
             :display_equipment_slot, :display_as_equipment_slot,
             :equip_time, :unequip_time, :can_equip?,
             :to => :item_object

    ###############
    ### Install ###
    ###############    
    arm_install do |m|
      m.create_table table_name do |t|
        t.integer   :item_name_id, :null => false
        t.integer   :item_list_id, :null => false
        t.integer   :amount,       :null => false, :default => 1, :limit => 5, :unsigned => true
        t.timestamp :updated_at
      end
    end
    arm_install('Ricer4::Plugins::Shadowlamb::Core::ItemName' => 1, 'Ricer4::Plugins::Shadowlamb::Core::ItemList' => 1) do |m|
      m.add_foreign_key table_name, :sl5_item_names, :name => :fk_item_names, :column => :item_name_id
      m.add_foreign_key table_name, :sl5_item_lists, :name => :fk_item_lists, :column => :item_list_id
    end

    ###############
    ### Display ###
    ###############    
    def display_list_item(number)
      "#{number}-#{display_name}"
    end

    def display_show_item(number)
      "#{display_list_item(number)} - #{displayinfo}" 
    end
    
    def display_name
      amountprefix + item_name.display_name + displayrunes
    end

    def display_name_selected
      selectedprefix + item_name.display_name + displayrunes
    end

    def amountprefix
      self.amount > 1 ? "#{self.amount}x" : ""
    end

    def selectedprefix
      @selected_amount > 1 ? "#{@selected_amount}x" : ""
    end
    
    def displayinfo
      item_name.displayinfo
    end

    def displayrunes
      out = []
      values.each do |value|
        out.push("#{value.short_label}:#{value.bonus_value}") if value.bonus_value > 0
      end
      out.count == 0 ? '' : (rune_appendix + out.join(';'))
    end

    ############
    ### Item ###
    ############
    def switch_item_list(new_list)
      old_list, self.item_list = self.item_list, new_list
      save!
      self
    end
    def stackable?
      item_name.stackable
    end
    
    def is_equipment?
      item_object.is_a?(Items::Equipment)
    end
    
    def compute_power
      1
    end
    
    def compare_with(item)
      item.compute_power - self.compute_power
    end
    
    def add_amount(amount)
      self.amount = self.amount + amount
      raise StandardError("Item#add_amount: #{self.display_name} is now <= 0!") if self.amount < 1
      self
    end
    
    def selected_amount=(amount=2222222)
      @selected_amount = self.amount.clamp(1, self.amount)
      self
    end
    
  end
end
