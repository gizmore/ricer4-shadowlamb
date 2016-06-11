module Ricer4::Plugins::Shadowlamb::Core
  class Location < ActiveRecord::Base

    include Include::Base
    include Include::Guid
    include Include::Translates
    include Include::HasLocation
    arm_events
    
    include Include::Shadowevents

    attr_accessor :area
    
    self.table_name = 'sl5_locations'

    arm_cache

    ###############
    ### Install ###
    ###############
    arm_install do |m|
      m.create_table table_name do |t|
        t.string :klass_name, :null => false, :limit => 128, :charset => :ascii, :collation => :ascii_bin
      end
      m.add_index table_name, :klass_name, :unique => true, :name => :unique_location_names
    end
    
    ############
    ### GUID ###
    ############
    def display_name; "#{@area.display_name}/#{_display_name}"; end
    def default_name; self.class.name.rsubstr_from('::'); end
    
    #################
    ### Reachable ###
    #################
    def reachable_by?(party)
      @area.reachable_by?(party)
    end
    def reachable_by_area?(area)
      @area.reachable_by_area?(area)
    end
    
    ##############
    ### Loader ###
    ##############
    def self.install
      class_eval do |klass|
        klass.find_or_create_by(:klass_name => klass.name.substr_from('World::'))
      end
    end
    def self.locations_dir; File.dirname(__FILE__)+'/locations'; end
    def self.install_data_set
      Filewalker.traverse_files(locations_dir) do |path|
        shall_extend = path.index('/extend_') != nil
        shall_include = path.index('/include_') != nil
        if shall_extend || shall_include
          load path
          klass_name = path.rsubstr_from('/')[0..-4].camelize
          klass_name = "Ricer4::Plugins::Shadowlamb::Core::Locations::#{klass_name}"
          klass = Object.const_get(klass_name)
          self.extend klass if shall_extend
          self.include klass if shall_include
        end
      end
    end
    
    ######    
    def top_area(party)
      self.area.top_area(party)
    end

    
    ## Mark this location as featuring a command
    def self.add_shadowlamb_command(trigger_symbol)
      get_shadowlamb_commands.push(trigger_symbol)
    end
    
    def self.get_shadowlamb_commands
      define_class_variable(:@sl5_location_commands, [])
    end

  end
end
