module Ricer4::Plugins::Shadowlamb::Core
  class Gender < ActiveRecord::Base
      
    self.table_name = 'sl5_genders'
    
    arm_cache

    include Include::Base
    include Include::Dice
    include Include::HasValues
    include Include::Translates

    ###############
    ### Install ###
    ###############
    arm_install do |m|
      m.create_table table_name do |t|
        t.string :name, :null => false, :limit => 32, :collation => :ascii_bin, :charset => :ascii
      end
    end

    ###
    def human?; self.class.human?; end
    def self.human?; true; end

    def self.all_genders; @genders; end
    def self.get_gender(name); @genders[name.to_s]; end

    def to_label; t!("gender.#{self.name}") rescue self.name; end

    
    ##############
    ### Loader ###
    ##############
    def self.gender_const(gender_name); Object.const_get("Ricer4::Plugins::Shadowlamb::Core::Genders::#{gender_name.camelize}"); end
    def self.genders_dir; File.dirname(__FILE__)+'/genders'; end
    def self.install_data_set
      @genders = {}
      Filewalker.traverse_files(genders_dir) do |path|
        load path
        klass_name = path.rsubstr_from('/')[0..-4]
        gender = gender_const(klass_name).find_or_create_by(:name => klass_name)
        gender.install_data_values
        @genders[klass_name] = gender
      end
    end
    def install_data_values
      data_file = get_data_file(:genders)
      self.values.destroy_all
      name_string = self.name_string
      data_file["attributes"]["base"][name_string].each do |k,v|
        self.save_base(k, v)
      end
      data_file["attributes"]["bonus"][name_string].each do |k,v|
        self.save_bonus(k, v)
      end
      data_file["combat"][name_string].each do |k,v|
        self.save_bonus(k, v)
      end
      data_file["skills"]["base"][name_string].each do |k,v|
        self.save_base(k, v)
      end
      data_file["skills"]["bonus"][name_string].each do |k,v|
        self.save_bonus(k, v)
      end
      data_file["spells"]["base"][name_string].each do |k,v|
        self.save_base(k, v)
      end
      data_file["spells"]["bonus"][name_string].each do |k,v|
        self.save_bonus(k, v)
      end
      bot.log.info("Loaded gender: #{name_string}")
    end

  end
end
