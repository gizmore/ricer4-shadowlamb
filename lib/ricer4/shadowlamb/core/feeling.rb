module Ricer4::Plugins::Shadowlamb::Core
  class Feeling < ActiveRecord::Base
    
    self.table_name = 'sl5_feelings'

    include Include::Base
    include Include::HasValues

    belongs_to :player, :class_name => Player.name
    
    arm_install('Ricer4::Plugins::Shadowlamb::Core::Player' => 1) do |m|
      m.create_table table_name do |t|
        t.integer :player_id, :null => false
        t.foreign_key :sl5_players, :name => :feelings_players, :column => :player_id, :on_delete => :cascade
      end
    end
    
  end
end