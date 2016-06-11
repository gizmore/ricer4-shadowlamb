module Ricer4::Plugins::Shadowlamb::Core
  class Levelup < ActiveRecord::Base
    
    self.table_name = 'sl5_levelups'

    include Include::Base
    include Include::HasValues

    belongs_to :owner, :polymorphic => true
    
    arm_install do |m|
      m.create_table table_name do |t|
        t.integer :owner_id,   :null => false
        t.string  :owner_type, :limit => 128, :null => false, :charset => :ascii, :collation => :ascii_bin
      end
      m.add_index table_name, [:owner_id, :owner_type], :unique => true, :name => :lvlup_owners
    end
    
  end
end