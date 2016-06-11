module Ricer4::Plugins::Shadowlamb::Core
  class Shadowverse
    
#    include Singleton
    def self.instance; @instance ||= self.new; end
    
    include Include::Base
    
    attr_reader :areas, :cities, :dungeons, :locations, :obstacles, :quests
    
    def initialize
      @mutex = Mutex.new
      clean_world
    end
    
    def mutex; @mutex; end
    def lock; @mutex.lock; end
    def unlock; @mutex.unlock; end
    
    def clean_world
      @areas, @cities, @dungeons = [], [], []
      @locations, @respawn_locations = [], []
      @obstacles = []
      @quests = []
    end
    
    #############
    ### Cache ###
    #############
    def add_area(area)
      area = area.install
      @areas.push(area)
      if area.is_partere?
        @cities.push(area) if area.is_a?(City)
        @dungeons.push(area) if area.is_a?(Dungeon)
      end
      bot.log.info("Loaded area: #{area.guid}")
    end
    
    def get_area(path)
      @areas.each{|area|return area if area.guid == path}
      nil
    end
    
    def get_location(path)
      @locations.each{|location|return location if location.guid == path}
      nil
    end
    
    def add_location(location)
      location = location.install
      @locations.push(location)
      bot.log.info("Loaded location: #{location.guid}")
    end
    
    def add_respawn_location(location)
      @respawn_locations.push(location.name)
      bot.log.info("Marked respawn location: #{location.guid}")
    end

    def add_obstacle(obstacle)
      @obstacles.push(obstacle)
      bot.log.info("Loaded obstacle: #{obstacle.guid}")
    end
    
    def add_quest(quest)
      quest = quest.install
      @quests.push(quest)
      bot.log.info("Loaded quest: #{quest.guid}")
    end
    
    ###############################
    ### Locate respawn location ###
    ###############################
    def respawn_location(party)
      min_distance, respawn_at = 2123123123, nil
      @respawn_locations.each do |location|
        distance = location.distance_to(party)
        if distance < min_distance
          min_distance, respawn_at = distance, location
        end
      end
      respawn_at or raise Ricer4::ConfigException.new("Party wihout area: #{party.id} #{party.inspect}")
    end
    
    ##############
    ### Loader ###
    ##############
    def after_load
      load_respawn_locations
      load_parent_areas
      player_factory.load_stationary_npcs
      init_quests
    end
    
    def init_quests
      @quests.each do |quest|
        quest.sl5_init_quest
      end
    end
    
    def load_respawn_locations
      respawn, @respawn_locations = @respawn_locations, []
      @locations.each do |location|
        location.area = locate_area(location)
        @respawn_locations.push(location) if respawn.include?(location.class.name)
      end
    end
    
    def load_parent_areas
      bot.log.info("Building parent area tree")
      @areas.sort!{|a,b|a.squarem-b.squarem}
      @areas.each{|area|load_parent_area(area)}
    end
    
    def load_parent_area(area)
      unless area.is_world?
        parent_area = locate_area(area)
        parent_area.add_child_area(area)
        bot.log.debug("Area #{area.display_name} has parent #{parent_area.display_name}")
      end
    end
    
    ################################
    ### Locate area and location ###
    ################################
    def locate_area(location)
      candidates = @areas.select{|area|area.overlaps?(location, false)}
      candidates.sort!{|a,b| a.squarem - b.squarem }
      candidates.sort!{|a,b| (b.floor - location.floor) - (a.floor - location.floor) }
      return candidates.first if candidates.first
      raise StandardError.new("shadowverse#locate_area #{location.default_name} is not in any area.")
    end
    
    def locate_location(party)
      @locations.each{|location|return location if location.overlaps?(party)}
      false
    end
    
    def location_by_id(location_id)
      @locations.each{|location|return location if location.id == location_id}
      raise Ricer4::ExecutionException.new("Shadowverse#location_by_id failed for ID: #{location_id}")
    end
    
    def location_by_guid(location_guid)
      @locations.each{|location|return location if location.guid == location_guid}
      raise Ricer4::ExecutionException.new("Shadowverse#location_by_guid failed for GUID: #{location_guid}")
    end
    
  end
end
