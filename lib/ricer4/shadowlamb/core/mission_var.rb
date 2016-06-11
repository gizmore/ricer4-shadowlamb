module Ricer4::Plugins::Shadowlamb::Core
  class MissionVar < ActiveRecord::Base

    self.table_name = 'sl5_mission_vars'

    include Include::Base
    include Include::Translates
    
#    belongs_to :mission,  :class_name => "Ricer4::Plugins::Shadowlamb::Core::Mission"
    
    ###############
    ### Install ###
    ###############
    arm_install('Ricer4::Plugins::Shadowlamb::Core::Mission' => 1) do |m|
      m.create_table table_name do |t|
        t.integer :mission_id,  :null => false
        t.string  :name,        :null => false, :charset => :ascii, :collate => :ascii_bin, :limit => 32
        # t.string  :parameter,   :null => false, :charset => :ascii, :collate => :ascii_bin, :limit => 32
        t.string  :value,       :null => false, :charset => :ascii, :collate => :ascii_bin
      end
    end

    arm_install('Ricer4::Plugins::Shadowlamb::Core::Mission' => 1) do |m|
      m.add_foreign_key table_name, :sl5_missions, :name => :mission_for_var,  :column => :mission_id, :on_delete => :cascade
      m.add_index       table_name, :mission_id,   :name => :players_missions
    end
    
    ###
    def get_value
      self.value
    end

    def set_value(value)
      self.value = value.to_s
      self.save!
      value
    end

  end
end
