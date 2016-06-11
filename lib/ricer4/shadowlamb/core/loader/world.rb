module Ricer4::Plugins::Shadowlamb::Core
  class Loader::World
    
#    include Singleton
    def self.instance; @instance ||= self.new; end
    
    
    include Include::Base
    include Include::Dice
    
    def world_dir; "#{shadowlamb_dir}/world"; end

    def load_world
      bot.log.debug("Loader::World#load_world")
      # Load all classes
      Filewalker.traverse_files(world_dir, '*.rb') do |path|
        load_rb_path(path)
      end
      mob_factory.after_loading_world_files
      # Parse mob files
      Filewalker.traverse_files(world_dir, 'mobs.yml') do |path|
        load_mob_file(path)
      end
      shadowverse.after_load
    end
    
    def load_rb_path(path)
      begin
        load path
        bot.log.info("Loaded world file: #{path.substr_from('/world/')}")
      rescue StandardError => e
        bot.log.error("ERROR IN: #{path}")
        raise # unless bot.genetic_rice
        bot.log.exception(e)
      end
    end
    
    def load_mob_file(path)
      yaml = YAML.load_file(path)
      yaml.each do |mob_path, mob_definition|
        validate_mob_definition!(path, mob_path, mob_definition)
        mob_factory.add_mob_definition(mob_path, mob_definition)
     end
    end
    
    def validate_mob_definition!(path, mob_path, mob_definition)
      begin
        validate_mob_ai!(mob_definition, "ai")
        validate_mob_name!(mob_definition, "name")
        validate_mob_race!(mob_definition, "race")
        validate_mob_gender!(mob_definition, "gender")
        validate_mob_professions!(mob_definition, "professions")
        validate_mob_values!(mob_definition, "base")
        validate_mob_values!(mob_definition, "bonus")
        validate_mob_items!(mob_definition, "equipment")
        validate_mob_items!(mob_definition, "inventory")
        validate_mob_items!(mob_definition, "cyberware")
      rescue SystemExit, Interrupt
        raise
      rescue StandardError => e
        bot.log.exception(e)
        puts "\n\n#{mob_definition.inspect}\n\n"
        raise Ricer4::ConfigException.new("NPC #{mob_path} has an invalid definition in #{path}.")
      end
    end

    def validate_mob_ai!(values, section)
      return if values[section].nil?
      Array(values[section]).each do |ai_includes|
        ai_includes.to_s.split(',').each do |ai_include|
          get_ai(ai_include) or raise Ricer4::ConfigException.new("NPC has unknown ai script: #{ai_include}")
        end
      end
    end
    
    def validate_mob_name!(values, section)
    end

    def validate_mob_race!(values, section)
      return if values[section].nil? || values[section].empty?
      Array(values[section]).each do |race_gmi|
        race_gmi.split(',').each do |race|
          get_race(race.ltrim('0123456789.%')) or raise Ricer4::ConfigException.new("Unknown race: #{race}")
        end
      end
    end
    
    def validate_mob_gender!(values, section)
      return if values[section].nil? || values[section].empty?
      Array(values[section]).each do |gender_gmi|
        gender_gmi.split(',').each do |gender|
          get_gender(gender.ltrim('0123456789.%')) or raise Ricer4::ConfigException.new("Unknown gender: #{gender}")
        end
      end
    end

    def validate_mob_professions!(values, section)
      return if values[section].nil? || values[section].empty?
      Array(values[section]).each do |profession_gmi|
        profession_gmi.split(',').each do |profession|
          get_profession(profession) or raise Ricer4::ConfigException.new("Unknown profession: #{profession}")
        end
      end
    end

    def validate_mob_values!(values, section)
      return if values[section].nil? || values[section].empty?
      values[section].each do |key, value|
        get_value_name(key)
        raise Ricer4::ConfigException.new("#{section} #{key} value not numeric: #{value}") unless (value.is_a?(Array) && is_gaussian?(value)) || (value.numeric?)
      end
    end

    def validate_mob_items!(values, section)
      return if values[section].nil? || values[section].empty?
      Array(values[section]).each do |gmi_item_string|
        item_factory.validate_yaml_items!('NPC', section, gmi_item_string.split(','))
      end
    end
    
  end
end
