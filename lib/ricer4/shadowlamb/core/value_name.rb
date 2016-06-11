module Ricer4::Plugins::Shadowlamb::Core
  class ValueName < ActiveRecord::Base
    
    self.table_name = 'sl5_value_names'

    arm_cache

    arm_events

    include Include::Base
    include Include::Crafting
    include Include::Translates

    def min_base; -10; end
    def min_bonus; 0; end
    def min_adjusted; 0; end

    def max_base; get_config(:max_base); end
    def max_bonus; get_config(:max_bonus); end
    def max_adjusted; get_config(:max_adjusted); end

    arm_install do |m|
      m.create_table table_name do |t|
        t.string :name, :null => false, :limit => 32, :collation => :ascii_bin, :charset => :ascii
      end
      m.add_index table_name, :name, :unique => true, :name => :unique_value_names
    end

    # All Overrides #
    def default; 0; end
    def priority; 50; end;
    def section; :computed; end
    def apply_to(player, adjusted); end
    def applies_to?(object); false; end
    # End Overrides #

    def value_key
      self.name
    end
    
    def display(base, adjusted)
      "#{to_label}: #{base}(#{adjusted})"
    end
    # def display_in_section(base, adjusted)
      # "#{to_label}: #{base}(#{adjusted})"
    # end
    
    def to_label
      I18n.t!("shadowlamb.values.#{self.name}.long") rescue self.name
    end

    def short_label
      I18n.t!("shadowlamb.values.#{self.name}.short") rescue self.name
    end
    
    #############
    ### Cache ###
    #############
    def self.all_values
      @values
    end
    
    def self.get_value_name(name)
      @values[name.to_s]
    end

    def self.get_value_name_i18n(name)
      name = name.downcase
      self.get_value_name(name) ||
      self.get_value_name_i18n_long(name) ||
      self.get_value_name_i18n_short(name)
    end
    
    def self.get_value_name_i18n_long(name)
      @values.each do |value|
        return value if value.to_label == name
      end
      nil
    end

    def self.get_value_name_i18n_short(name)
      @values.each do |value|
        return value if value.short_label == name
      end
      nil
    end

    ##############
    ### Loader ###
    ##############
    def self.value_const(name)
      const_get("Ricer4::Plugins::Shadowlamb::Core::ValueType::#{name.camelize}")
    end

    def self.value_types_dir
      File.dirname(__FILE__)+'/value_type'
    end
    def self.values_dir
      File.dirname(__FILE__)+'/values'
    end
    def self.spells_dir
      File.dirname(__FILE__)+'/spells'
    end
    
    def self.install_data_set
      @values = {}
      Filewalker.proc_files(value_types_dir, '*.rb') do |path|
        bot.log.info("Loaded GenericValueType: #{path.rsubstr_from('/')[0..-4]}")
        load path
      end
      Filewalker.traverse_files(values_dir, '*.rb') do |path|
        install_value_name(path)
      end
      Filewalker.proc_files(spells_dir, '*.rb') do |path|
        install_spell_value(path)
      end
      @values.sort_by { |key, value| value.priority }
    end
    
    def self.install_value_name(path)
      begin
        load path
        klass_name = path.rsubstr_from('/')[0..-4]
        value_klass = value_const(klass_name)
        value = value_klass.find_or_create_by(:name => klass_name)
        value.install_data_set if value.respond_to?(:install_data_set)
        @values[klass_name] = value
        bot.log.info("Loaded #{value.section} value: #{klass_name}");
      rescue
        puts "ERROR IN: #{path}"
        raise
      end
    end

    def self.install_spell_value(path)
      klass_name = path.rsubstr_from('/')[0..-4]
      value_klass = value_const('spell')
      value = value_klass.find_or_create_by(:name => klass_name)
      @values[klass_name] = value
      bot.log.info("Loaded #{value.section} value: #{klass_name}");
    end
    
  end
end
