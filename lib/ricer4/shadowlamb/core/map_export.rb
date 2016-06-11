module Ricer4::Plugins::Shadowlamb::Core
  class MapExport
    
    AREA = 1; LOCATION = 2; OBSTACLE = 3

    HUMAN = 6; MOB = 7; STATIONARY = 8; REALNPC = 9
    
#    include Singleton
    def self.instance; @instance ||= self.new; end

    include Include::Base
    
    def map_dir; File.dirname(__FILE__)+"/tmp"; end
    def map_file(filename)
      dir = "#{map_dir}/#{I18n.locale}"
      FileUtils.mkdir_p(dir) unless File.directory?(dir)
      "#{dir}/#{filename}"
    end

    def areas; shadowverse.areas; end
    def locations; shadowverse.locations; end
    def obstacles; shadowverse.obstacles; end

    def humans; player_factory.humans; end
    def mobs; player_factory.mobs; end
    def stationaries; player_factory.stationary; end
    def realnpcs; player_factory.realnpc; end
    
    def write_static_files
      write_dynamic_files
      write_files { write_huge_map_file }
    end

    def write_files(&block)
      ActiveRecord::Magic::Locale.all.each do |locale|
        I18n.locale = locale.iso
        yield block
      end
    end

    def write_dynamic_files
      I18n.locale = 'bot'
      write_player_file
      I18n.locale = 'en'
    end
    
    def write_huge_map_file
      File.open(map_file('world.json'),'w') {|file|
        file.puts("[")
        draw_areas(file)
        draw_locations(file)
        draw_obstacles(file)
        draw_stationaries(file)
        file.puts("]")
      }
    end

    def write_player_file
      File.open(map_file('players.json'),'w') {|file|
        file.puts("[")
        draw_humans(file)
        draw_realnpcs(file)
        file.puts("]")
      }
    end
   
    def draw_areas(file); areas.each{|area|draw_area(area,file)}; end
    def draw_locations(file); locations.each{|loc|draw_location(loc,file)}; end
    def draw_obstacles(file); obstacles.each{|obs|draw_obstacle(obs,file)}; end
    def draw_humans(file); humans.each{|h|draw_human(h,file)}; end
    def draw_mobs(file); mobs.each{|m|draw_mob(m,file)}; end
    def draw_stationaries(file); stationaries.each{|s|draw_stationary(s,file)}; end
    def draw_realnpcs(file); realnpcs.each{|r|draw_realnpc(r,file)}; end
    
    def draw_area(area, file)
      file.puts([AREA, area.object_id, area.lat, area.lon, area.lat, area.lon, area.display_name, area.displayinfo].to_json)
    end

    def draw_location(loc, file)
      file.puts([LOCATION, loc.object_id, loc.lat, loc.lon, loc.lat, loc.lon, loc.display_name, loc.displayinfo].to_json)
    end

    def draw_obstacle(obstacle, file)
      file.puts([OBSTACLE, obstacle.object_id, obstacle.lat, obstacle.lon, obstacle.display_name, obstacle.displayinfo].to_json)
    end
    
    def draw_human(human, file); draw_npc(HUMAN, human, file); end
    def draw_mob(mob, file); draw_npc(MOB, mob, file); end
    def draw_stationary(stationary, file); draw_npc(STATIONARY, stationary, file); end
    def draw_realnpc(realnpc, file); draw_npc(REALNPC, realnpc, file); end
    
    def draw_npc(type_id, npc, file)
      p = npc.party
      file.puts([type_id, npc.object_id, p.lat, p.lon, npc.display_name, npc.displayinfo].to_json)
    end

  end
end
