module Ricer4::Plugins::Shadowlamb::Core
  class ProfessionName < ActiveRecord::Base
      
    self.table_name = 'sl5_profession_names'
    
    arm_cache

    include Include::Base
    include Include::Dice
    include Include::HasValues
    include Include::Translates

    extend Extend::HasRequirements

    ###############
    ### Install ###
    ###############
    arm_install do |m|
      m.create_table table_name do |t|
        t.string :name, :null => false, :limit => 32, :collation => :ascii_bin, :charset => :ascii
      end
      m.add_index table_name, :name, :unique => true, :name => :unique_professions
    end
    
    ###
    def to_label; t("profession.#{self.name}"); end
    def self.all_professions(); @professions; end
    def self.get_profession(name); @professions[name.to_s]; end

    ##############
    ### Loader ###
    ##############    
    def self.professions_dir; File.dirname(__FILE__)+'/professions'; end
    def self.profession_const(profession_name); Object.const_get("Ricer4::Plugins::Shadowlamb::Core::Professions::#{profession_name.camelize}"); end
    def self.install_data_set
      @professions = {}
      Filewalker.proc_files(professions_dir, '*.rb') do |path|
        load path
        klass_name = path.rsubstr_from('/')[0..-4]
        profession = profession_const(klass_name).find_or_create_by(:name => klass_name)
        begin
          profession.install_data_values
          @professions[klass_name] = profession
        rescue StandardError => e
          bot.log.error("ERROR IN: #{path}")
          raise
        end
      end
    end
    def install_data_values

      name_string = self.name_string
      
      data_file = get_data_file(:professions)
      
      saved_values = []

      unless data_file["base"][name_string].nil?
        data_file["base"][name_string].each do |k,v|
          self.save_base(k, v)
          saved_values.push(k.to_s)
        end
      end

      unless data_file["bonus"][name_string].nil?
        data_file["bonus"][name_string].each do |k,v|
          self.save_bonus(k, v)
          saved_values.push(k.to_s)
        end
      end
      
      values.each do |value|
        value.destroy! unless saved_values.include?(value.value_key.to_s)
      end
      
      bot.log.info("Loaded profession: #{name_string}")
    end

  end
end
