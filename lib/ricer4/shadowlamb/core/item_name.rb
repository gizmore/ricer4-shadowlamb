module Ricer4::Plugins::Shadowlamb::Core
  class ItemName < ActiveRecord::Base
    
    include Include::Base
    include Include::Translates

    attr_accessor :stackable

    self.table_name = 'sl5_item_names'

    arm_cache

    ###############
    ### Install ###
    ###############
    arm_install do |m|
      m.create_table table_name do |t|
        t.string :name, :null => false, :limit => 64, :collation => :ascii_bin, :charset => :ascii
      end
      m.add_index table_name, :name, :unique => true, :name => :unique_item_names
    end
    
    ############
    ### Guid ###
    ############
    def i18n_key; @i18n_key ||= "shadowlamb.items.#{self.name}"; end
    def display_name;_display_name; end
    def _display_name; t!("#{i18n_key}.name") rescue default_name; end
    def default_name; self.name; end
    def displayinfo;_displayinfo; end
    def _displayinfo; t!("#{i18n_key}.info") rescue defaultinfo; end
    def defaultinfo; "This item has no description."; end

    #############
    ### Cache ###
    #############
    def item_klass; self.class.get_item_const(self.name); end
    def item_name_klass; self.class.get_item_name(self.name); end

    def self.all_item_const; @items; end
    def self.all_item_names; @item_names; end
    def self.get_item_const(name); @items[name]; end
    def self.get_item_name(name); @item_names[name]; end
    def self.get_item_values(name); @item_values[name]; end
    def self.get_item_stackable(name); @item_names[name].stackable; end

    ##############
    ### Loader ###
    ##############
    def self.items_data_dir; File.dirname(__FILE__)+'/data/items/'; end
    def self.items_dir; File.dirname(__FILE__)+'/items/'; end
    def self.install_data_set()
      @items, @item_names, @item_values = {}, {}, {}
      load_item_classes
      Filewalker.proc_files(items_data_dir, '*.yml') do |path|
        install_item_data_set(path)
      end
      install_requirements
    end
    def self.install_item_data_set(path)
      YAML.load_file(path).each do |item_type, items_for_type|
        items_for_type.each do |name, data|
          data = {} if data.nil?
          raise Ricer4::ConfigException.new("#{item_type} #{name} has werid values. This should be Hash: #{data}") unless data.is_a?(Hash)
          raise Ricer4::ConfigException.new("Duplicate item name: #{name} of type #{item_type}") unless @items[name].nil?
          @items[name] = @item_classes[name] || @item_classes[item_type]
          raise Ricer4::ConfigException.new("No item class for item: #{name} of type #{item_type}") if @items[name].nil?
          validate_item_data!(item_type, name, data)
          @item_names[name] = self.where(:name => name).first_or_create
          @item_names[name].stackable = detect_stackable?(data)
          @item_values[name] = data
          bot.log.info("Loaded item: #{name}")
        end
      end
    end
    
    def self.detect_stackable?(data)
      data.each{|key, value|return false if value.is_a?(Array)}
      return true
    end
    
    def self.install_requirements
      get_data_file(:item_requirements).each do |key, requirements|
      end
    end

    def self.validate_item_data!(type, name, data)
      data.each do |key, value|
        # Check valid value_name
        get_value_name(key) or raise Ricer4::ConfigException.new("#{type} Item #{name} has unknown value_key: #{key}")
        # Check if a nice integer/array
        Array(value).each do |intval|
          raise Ricer4::ConfigException.new("#{type} Item #{name} has non integer values for value_key #{key}: #{value.inspect}") unless intval.integer?
        end
      end
    end
    
    def self.load_item_classes
      @item_classes = {}
      Filewalker.traverse_files(items_dir, '*.rb') do |path|
        load path
        klass_name = path.rsubstr_from('/')[0..-4].camelize
        item_klass = Object.const_get("Ricer4::Plugins::Shadowlamb::Core::Items::#{klass_name}")
        @item_classes[klass_name] = item_klass
      end
    end
    
  end
end
