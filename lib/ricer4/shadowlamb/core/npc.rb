load File.expand_path("../player.rb", __FILE__)
module Ricer4::Plugins::Shadowlamb::Core
  class Npc < Player

    def is_human?; false; end
    def is_npc?; true; end
    def is_abstract?; false; end

    #############
    ### Names ###
    #############
    def npc_path; self.class.npc_path; end
    def self.npc_path; name.substr_from('World::').gsub('::', '/'); end
    
    def i18nkey; @_i18nkey ||= ("shadowlamb.world.#{npc_path.gsub('/', '.').downcase}"); end
    
    def name
      I18n.t!("#{i18nkey}.name") rescue self.playername
    end
    
    def full_name
      "#{self.name}[#{@npc_obj_id}]"
    end

    def random_name
      data, gender = get_data_file(:names), self.gender.name
      data[race.name][gender].sample rescue data[gender].sample
    end
    
    def npc_obj_id
      @npc_obj_id || 0
    end

    def npc_obj_id=(index)
      @npc_obj_id = index
    end

    ############
    ### GUID ###
    ############
    def guid; self.class.guid; end
    def self.guid; name.substr_from('World::'); end
    def i18n_key; @i18n_key ||= guid.downcase.gsub('::', '.'); end
    def display_name; "\x02#{self.full_name}\x02"; end
#    def displayinfo; t!("world.#{i18n_key}.name") rescue i18n.key; end
    def displayinfo; t!("world.#{i18n_key}.info") rescue i18n_key; end
    def player_name; display_name; end
    
    #################
    ### Messaging ###
    #################
    def localize!; self; end
    def send_message(text)
      bot.log.debug("NPC #{self.full_name} send_message: #{text}")
    end

    ##########
    ### AI ###
    ##########
    NO_GOALS = []
    
    def goals; @goals || NO_GOALS; end
    
    def goal
      @goals.first
    end
    
    def ai_scripts; @_scripts ||= []; end
    # def include_ai(*ai_includes)
      # Array(ai_includes).each do |ai_include|
        # self.extend("Ai::#{ai_include}")
      # end
    # end
    def init_ai_scripts
      bot.log.debug("Npc#init_ai_scripts")
      define_class_variable(:@sl5_ai_scripts, []).each do |script|
        init_ai_script(script)
      end
      self
    end
    def init_ai_script(options={})
      @goals ||= []
      bot.log.debug("Npc#init_ai_script(#{options.inspect})")
      script = get_ai(options[:script]).new
      script.player = self
      script.init(options)
      ai_scripts.push(script)
      self
    end
    
    ##################
    ### Has Values ###
    ##################
    def add_npc_base(key, value); self.levelup.add_base(key, value); end
    def add_npc_bonus(key, value); self.levelup.add_bonus(key, value); end
    def add_npc_value(key, base, bonus); add_npc_base(key, base); add_npc_bonus(key, bonus); end

    def set_npc_base(key, value); self.levelup.set_base(key, value); end
    def set_npc_bonus(key, value); self.levelup.set_bonus(key, value); end
    def set_npc_value(key, base, bonus); set_npc_base(key, base); set_npc_bonus(key, bonus); end
    def set_npc_boni(*pairs); pairs.each do |key, value| set_npc_bonus(key, value); end; end

    ##############
    ### Events ###
    ##############    
    def sl5_npc_before_definition
      puts "Default mob sl5_npc_before_definition"
    end

    def sl5_npc_after_definition
      puts "Default mob sl5_npc_after_definition"
    end
    
    def sl5_npc_after_spawned_for(party)
      puts "Default mob sl5_npc_after_spawned_for"
    end
    
  end
end
