module Ricer4::Plugins::Shadowlamb::Core
  class Value < ActiveRecord::Base
    
    self.table_name = 'sl5_values'
    
    belongs_to :value_name, :class_name => "Ricer4::Plugins::Shadowlamb::Core::ValueName"

    belongs_to :owner, :polymorphic => true
    
    def value_klass; ValueName.get_value_name(value_key); end
    
    delegate :value_key, :short_label, :to_label, :computed?, :default, :to => :value_name
    delegate :section, :to => :value_klass
    
    arm_install('Ricer4::Plugins::Shadowlamb::Core::ValueName' => 1) do |m|
      m.create_table table_name do |t|
        t.integer :value_name_id, :limit => 4,   :null => false, :unsigned => true
        t.integer :owner_id,      :limit => 11,  :null => false
        t.string  :owner_type,    :limit => 128, :null => false, :charset => :ascii, :collation => :ascii_bin
        t.integer :base_value,    :limit => 5,   :default => 0
        t.integer :bonus_value,   :limit => 5,   :default => 0
      end
      m.add_index       table_name, [:owner_id, :owner_type], :name => :value_owners
    end

    arm_install('Ricer4::Plugins::Shadowlamb::Core::ValueName' => 1) do |m|
      m.add_foreign_key table_name, :sl5_value_names, :name => :value_names, :column => :value_name_id
    end

    def section_is?(section)
      self.section == section
    end
    
    def is_learned?()
      self.base_value >= 0
    end
    
    def can_learn?()
      self.base_value >= -1
    end
    
    def adjusted_value
      self.base_value + self.bonus_value
    end
    
    def apply_to(player)
      self.value_klass.apply_to(player, self.adjusted_value)
    end
    
    def display
      value_klass.display(self.base_value, adjusted_value)
    end
    
  end
end
