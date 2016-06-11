module Ricer4::Plugins::Shadowlamb::Core
  class Quest < ActiveRecord::Base

    self.table_name = 'sl5_quests'

    arm_cache
    arm_named_cache :name, Proc.new{|values|values[:name].to_s.camelize.gsub('/', '::')}
    
    arm_events

    include Include::Base
    include Include::Guid
    include Include::Translates
    include Include::IsQuest

    ##################
    ### Translates ###
    ##################
    def tkey_partial; @sl5_quest_tkey ||= self.name.downcase.gsub('::', '.'); end
    def tkey(key); key.is_a?(Symbol) ? "shadowlamb.quest.#{tkey_partial}.#{key}" : key; end
    def _display_name; t!(:name) rescue default_name; end
    def _displayinfo; t!(:info) rescue t("shadowlamb.quest.quest_info"); end
    def display_accept; t(:accept) rescue t("shadowlamb.quest_accept"); end
    def display_list_item(number)
      t("shadowlamb.quest.list_item", number: number, quest: self.display_name)
    end
    def display_show_item(number)
      t("shadowlamb.quest.show_item", number: number, quest: self.display_name, info: self.displayinfo)
    end

    ###############
    ### Install ###
    ###############
    arm_install do |m|
      m.create_table table_name do |t|
        t.string :name, :null => false, :limit => 128, :collation => :ascii_bin, :charset => :ascii
      end
      m.add_index table_name, :name, :unique => true, :name => :unique_quest_names
    end
    
    def self.install
      class_eval do |klass|
        find_or_create_by(:name => name.substr_from('World::'))
      end
    end
    
    def sl5_init_quest
        
    end
    ##############
    ### Loader ###
    ##############

  end
  
end
