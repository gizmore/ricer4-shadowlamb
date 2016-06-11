module Ricer4::Plugins::Shadowlamb::Core
  class Action < ActiveRecord::Base

    include Include::Base
    include Include::Translates
    arm_events

    self.table_name = 'sl5_actions'

    arm_cache

    arm_install do |m|
      m.create_table table_name do |t|
        t.string :name, :null => false, :limit => 32, :collation => :ascii_bin, :charset => :ascii
      end
    end

    def self.actions_dir; File.dirname(__FILE__)+'/actions'; end
    def self.action_const(name); Object.const_get("Ricer4::Plugins::Shadowlamb::Core::Actions::#{name.camelize}"); end
    def self.install_data_set
      @actions = {}
      Filewalker.traverse_files(actions_dir, '*.rb') do |path|
        load path
        klass_name = path.rsubstr_from('/')[0..-4]
        action = action_const(klass_name).find_or_create_by(:name => klass_name)
        @actions[klass_name] = action
      end
    end

    def self.valid?(name); get_action(name) != nil; end

    def self.get_action(name); @actions[name.to_s]; end

    def target_id(party, target); nil; end
    
    def display_action(party)
      t("shadowlamb.action.#{self.class.name.demodulize.downcase}")
    end
    
    def continue_message(party)
      t("shadowlamb.msg_continue_action", action: self.display_action(party))
    end

  end
end
