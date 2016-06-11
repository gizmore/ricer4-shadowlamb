module Ricer4::Plugins::Shadowlamb::Core
  class Race < ActiveRecord::Base
  
    self.table_name = 'sl5_races'

    arm_cache
    
    include Include::Base
    include Include::Dice
    include Include::HasValues
    include Include::Translates
    include Include::SpawnsItems
    
    ###############
    ### Install ###
    ###############
    arm_install do |m|
      m.create_table table_name do |t|
        t.string :name, :null => false, :limit => 32, :collation => :ascii_bin, :charset => :ascii
      end
      m.add_index table_name, :name, :unique => true, :name => :unique_race_names
    end

    ##    
    def human?; self.class.human?; end
    def self.human?; false; end
    def to_label; t!("shadowlamb.races.#{self.name}.long") rescue self.name; end
    def short_label; t!("shadowlamb.races.#{self.name}.short") rescue self.name; end

    ##############
    ### Loader ###
    ##############
    def self.all_races; @races; end
    def self.get_race(name); @races[name.to_s]; end
    def self.races_dir; File.dirname(__FILE__)+'/races'; end
    def self.install_data_set
      @races = {}
      Filewalker.traverse_files(races_dir, '*.rb') do |path|
        load path
        klass_name = path.rsubstr_from('/')[0..-4]
        race = race_const(klass_name).find_or_create_by(:name => klass_name)
        begin
          race.install_data_values
          @races[klass_name] = race
        rescue StandardError => e
          bot.log.error("Race #{klass_name} has invalid yml definition. PATH: #{path}")
          raise
        end
      end
    end
    def self.race_const(race_name); Object.const_get("Ricer4::Plugins::Shadowlamb::Core::Races::#{race_name.camelize}"); end
    def install_data_values
      data_file = human? ? get_data_file(:races) : get_data_file(:npc_races)
      name_string = self.name_string
      altered_values = [] # Later destroy all valuekeys that have not been altered here
      data_file["attributes"]["base"][name_string].each do |k,v|
        altered_values.push(k) and self.save_base(k, v)
      end
      data_file["attributes"]["bonus"][name_string].each do |k,v|
        altered_values.push(k) and self.save_bonus(k, v)
      end
      data_file["combat"][name_string].each do |k,v|
        altered_values.push(k) and self.save_bonus(k, v)
      end
      data_file["skills"]["base"][name_string].each do |k,v|
        altered_values.push(k) and self.save_base(k, v)
      end
      data_file["skills"]["bonus"][name_string].each do |k,v|
        altered_values.push(k) and self.save_bonus(k, v)
      end
      data_file["spells"]["base"][name_string].each do |k,v|
        altered_values.push(k) and self.save_base(k, v)
      end
      data_file["spells"]["bonus"][name_string].each do |k,v|
        altered_values.push(k) and self.save_bonus(k, v)
      end
      # Destroy newly unused values 
      self.values.each do |value|
        value.destroy unless altered_values.include?(value.value_key)
      end
      if human?
        validate_race_items!(data_file, "inventory")
        validate_race_items!(data_file, "equipment")
        bot.log.info("Loaded human race: #{name_string}")
      else
        bot.log.info("Loaded npc-only race: #{name_string}")
      end
    end
    
    def validate_race_items!(item_data, section)
      item_factory.validate_yaml_items!("Race #{name_string}", section, item_data[section][name_string])
    end
    
  end
end
