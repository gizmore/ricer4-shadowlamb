module Ricer4::Plugins::Shadowlamb
  class Mount < Core::Command
    
    trigger_is :mount
    
    works_when :talking, :inside, :outside, :goto, :move, :explore, :travel
    
#    has_usage  '<string> <sl_mount_item>', function: :_execute_mount
#    has_usage  '<string> <sl_inventory_item>', function: :_execute_mount
    
    has_usage '', function: :execute_mount
    def execute_mount()
    end

  end
end
