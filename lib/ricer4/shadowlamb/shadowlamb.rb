require "geocoder"

load File.expand_path("../shadowmodules.rb", __FILE__)
load File.expand_path("../shadowthreads.rb", __FILE__)

module Ricer4::Plugins::Shadowlamb
  class Shadowlamb < Ricer4::Plugin
    
    SHADOWDIR ||= File.dirname(__FILE__)

    include Shadowthreads
    
    def shadowlamb_version; 5.0; end

    trigger_is  :sl

    priority_is 45

    version_is 2
    date_is '2016-1-14'
    author_is :gizmore
    license_is :properitary
    
    ## Maximum screw
    has_setting name: :max_level,    scope: :bot, permission: :responsible, type: :integer, min: 1, max: 10000, default: 250
    has_setting name: :max_base,     scope: :bot, permission: :responsible, type: :integer, min: 1, max: 10000, default: 250
    has_setting name: :max_bonus,    scope: :bot, permission: :responsible, type: :integer, min: 0, max: 10000, default: 250
    has_setting name: :max_adjusted, scope: :bot, permission: :responsible, type: :integer, min: 0, max: 10000, default: 750
    
    ## Shadowtime
    WORLD_STARTED_AT ||= DateTime.new(2048, 1, 1, 13, 37, 42)
    has_setting name: :gamespeed,    scope: :bot, permission: :responsible, type: :integer,  default: 10, min: 1, max: 20
    has_setting name: :shadowtime,   scope: :bot, permission: :responsible, type: :datetime, default: WORLD_STARTED_AT
#    has_setting name: :tickseconds,  scope: :bot, permission: :responsible, type: :integer,  default: 12, min: 1, max: 128
#    has_setting name: :global_rm,    scope: :bot, permission: :responsible, type: :boolean,  default: false
    
    ## Evil shortcut manipulation    
#    has_setting name: :shortcut, scope: :user,    permission: :public,   type: :string, pattern: /^[-*#,.!\"§$%&_<x]$/, default: '#'
#    has_setting name: :shortcut, scope: :channel, permission: :operator, type: :string, pattern: /^[-*#,.!\"§$%&_<x]$/, default: '#'
#    def shortcut; get_setting(:shortcut); end
    # def on_privmsg
      # shortcut = self.shortcut
      # unless shortcut == 'x'
        # unless current_message.is_trigger_char?
          # if (privmsg_line[0] == shortcut)
            # current_message.args[1] = "#{current_message.trigger_char}#{trigger} #{line[1..-1]}"
          # end
        # end
      # end
    # end

    ## Installer
    ACTIVE_RECORD_CLASSES ||= [  
      'ValueName', 'Value', 'ItemName', 
      'Race', 'Gender', 'ProfessionName', 'Profession',
      'Quest', 'Mission', 'MissionVar',
      'Player', 'NpcName',
      'Feeling', 'Levelup', 'Effect', 'Spell',
      'Word', 'Knowledge',
      'Item', 'ItemList',
      'Area', 'Location', 'Action', 'Party',
    ]
    def active_record_classes(&block)
      ACTIVE_RECORD_CLASSES.each do |klass|
        klass = Ricer4::Plugins::Shadowlamb::Core.const_get(klass)
        yield(klass)
      end
    end

    def plugin_init
      load_shadowlamb
      arm_subscribe('ricer/ready') do
        factory.startup_active_parties
        shadowthreads
      end
      # arm_subscribe('ricer/reload') do
      # end
    end
    
    def load_shadowlamb
      load_shadowlamb_code
      ActiveRecord::Magic::Update.run
      install_data_set
      load_ai
      load_area_helpers
      mob_factory.plugin_reload
      Ricer4::Plugins::Shadowlamb::Core::Loader::World.instance.load_world
      arm_publish('world/loaded')
#      load_core
      # Kick it!
#      factory.startup_active_parties
    end

    def load_shadowlamb_code
      Filewalker.traverse_files(SHADOWDIR+"/core/include", '*.rb') do |path|
        load path
      end
  #    Filewalker.traverse_files(SHADOWDIR+"/export", '*.rb') do |path|
  #      load path
  #    end
      Filewalker.traverse_files(SHADOWDIR+"/core/extend", '*.rb') do |path|
        load path
      end
      Filewalker.traverse_files(SHADOWDIR+"/core/items", '*.rb') do |path|
        load path
      end
      Filewalker.traverse_files(SHADOWDIR+"/core", '*.rb') do |path|
        load path
      end
    end
  
    
    # def core_dir; File.dirname(__FILE__)+'/core'; end
    # def load_core
      # Filewalker.proc_files(core_dir, '*.rb') do |path|
        # klass_name = path.rsubstr_from('/')[0..-4].camelize
        # Object.const_get("Ricer4::Plugins::Shadowlamb::Core::#{klass_name}")
      # end
    # end
    
    def install_data_set
      active_record_classes do |klass|
        klass.install_data_set if klass.respond_to?(:install_data_set)
      end
      # Filewalker.classes_do(Ricer4::Plugins::Shadowlamb::Core) do |klass|
        # if klass.respond_to?(:install_data_set)
          # byebug
          # klass.install_data_set
        # end
      # end
    end
    
    def ai_dir; File.dirname(__FILE__)+'/core/ai'; end
    def npcs_dir; File.dirname(__FILE__)+'/core/npcs'; end
    def load_ai
      bot.log.debug("Shadowlamb#load_ai")
      Filewalker.traverse_files(npcs_dir, '*.rb') do |path|
        bot.log.debug("Shadowlamb#load_ai NPC: #{path}")
        load path
      end
      Filewalker.traverse_files(ai_dir, '*.rb') do |path|
        bot.log.debug("Shadowlamb#load_ai SCRIPT: #{path}")
        load path
      end
    end
    
    def areas_dir; File.dirname(__FILE__)+'/core/areas'; end
    def load_area_helpers
      Filewalker.traverse_files(areas_dir+'/extend', '*.rb') do |path|
        load path
        klass_const = Object.const_get(path.rsubstr_from('lib/')[0..-4].camelize)
        Core::Area.extend klass_const
      end
      Filewalker.traverse_files(areas_dir+'/include', '*.rb') do |path|
        load path
      end
    end
    
  end
end
