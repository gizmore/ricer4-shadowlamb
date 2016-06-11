module Ricer4::Plugins::Shadowlamb::Core
  class Spell < ActiveRecord::Base
    
    include Include::Base
    include Include::Dice
    include Include::Translates
    extend Extend::HasRequirements

    self.table_name = 'sl5_spells'

    arm_cache

    #################
    ### Installer ###
    #################
    arm_install do |m|
      m.create_table table_name do |t|
        t.string :name, :null => false, :limit => 32, :collation => :ascii_bin, :charset => :ascii
      end
      m.add_index table_name, :name, :unique => true, :name => :unique_spell_names
    end

    #############
    ### Cache ###
    #############    
    def self.all_spells; @spells; end
    def self.get_spell(name); @spells[name.to_s] or raise Ricer4::ConfigException.new("Unknown get_spell: #{name}"); end
    
    ##############
    ### Loader ###
    ##############
    def self.spells_dir; File.dirname(__FILE__)+'/spells'; end
    def self.install_data_set
      @spells = {}
      
      Filewalker.traverse_files(spells_dir, '*.rb') do |path|
        begin
          load path
          value_name = path.rsubstr_from('/')[0..-4]
          klass_name = value_name.camelize
          klass = Object.const_get("Ricer4::Plugins::Shadowlamb::Core::Spells::#{klass_name}")
          spell = klass.find_or_create_by(:name => value_name)
          @spells[klass_name] = spell
          bot.log.info("Loaded spell #{klass_name}")
        rescue StandardError => e
          bot.log.error("ERROR IN: #{path}")
          raise unless bot.genetic_rice
          bot.log.exception(e)
        end
      end
    end
    
    ################
    ### Abstract ###
    ################
    def cast(caster, target)
      raise Ricer4::NotImplemented.new("Spell #{self.class.name.demodulize} is not implemented yet.")
    end

  end
end
