module Ricer4::Plugins::Shadowlamb::Core
  class Area < ActiveRecord::Base
    
    include Include::Base
    include Include::Guid
    include Include::Dice
    include Include::HasLocation
    include Include::Translates
    include Include::Shadowevents
    extend  Include::Every
    arm_events
    
    self.table_name = 'sl5_areas'
    arm_cache

    ###############
    ### Install ###
    ###############
    arm_install do |m|
      m.create_table table_name do |t|
        t.string :name, :limit => 128, :null => false, :charset => :ascii, :collation => :ascii_bin
      end
      m.add_index table_name, :name, :unique => true, :name => :unique_area_names
    end
    
    ##############
    ### Loader ###
    ##############
    def self.install
      class_eval do |klass|
        klass.find_or_create_by(:name => klass.guid).init_area_tree
      end
    end
    
    ###############
    ### Display ###
    ###############
    # def display_name
      # self.class.guid
    # end
    
    #####################
    ### Parent Areas ####
    #####################
    def is_world?; false; end
    def init_area_tree; @child_areas = []; self; end
    def child_areas; @child_areas; end
    def add_child_area(area); @child_areas.push(area) unless @child_areas.include?(area); area.parent_area = self; self; end
    def parent_area; @parent_area; end
    def parent_area=(area); @parent_area = area; end
    def reachable_by?(party)
      reachable_by_area?(party.area)
    end
    def reachable_by_area?(area)
      return true if self == area
      mine_parents, them_parents = self.parent_areas, area.parent_areas
      them_parents.each{|_area|return true if mine_parents.include?(_area)}
      false
    end
    
    def top_area(party=nil)
      parent_areas.last
    end
    def parent_areas; @parent_areas ||= _parent_areas; end
    def _parent_areas
      parent, parents = self, []
      while parent
        parents.push(parent)
        break if parent.class.instance_variable_defined?(:@sl5_closed_area)
        parent = parent.parent_area
      end
      parents
    end
    def clamp_party(party)
      party.latitude = party.latitude.clamp(self.minlat+0.0001, self.maxlat-0.0001)
      party.longitude = party.longitude.clamp(self.minlon+0.0001, self.maxlon-0.0001)
      party.area = party.detect_area
      party.location = party.detect_location
    end
    
    #################
    ### Locations ###
    #################
    arm_subscribe('ricer/reload') do
      @parent_areas = nil
      @locations = nil
    end
    def random_coordinates; Ricer4::Plugins::Shadowlamb::Core::Coordinate.new(random_lat, random_lon); end
    def random_lat; rand_float(minlat, maxlat, 6); end
    def random_lon; rand_float(minlon, maxlon, 6); end
    def locations
      @locations ||= _locations
    end
    def add_location(location)
      locations.push(location)
    end
    def _locations
      shadowverse.locations.select{|location|location.area.top_area == self.top_area}      
    end
     
  end
end
