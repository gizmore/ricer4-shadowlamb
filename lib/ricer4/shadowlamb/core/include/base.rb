module Ricer4::Plugins::Shadowlamb::Core::Include::Base

  def self.included(base)
    base.extend Ricer4::Plugins::Shadowlamb::Core::Extend::Base
    include Ricer4::Include::Readable
  end
  
  def bot; Ricer4::Bot.instance; end

  def shadowtime; get_config(:shadowtime); end
  def shadowverse; Ricer4::Plugins::Shadowlamb::Core::Shadowverse.instance; end

  def mob_factory; Ricer4::Plugins::Shadowlamb::Core::MobFactory.instance; end
  def item_factory; Ricer4::Plugins::Shadowlamb::Core::ItemFactory.instance; end
  def gift_factory; Ricer4::Plugins::Shadowlamb::Core::GiftFactory.instance; end
  def quest_factory; Ricer4::Plugins::Shadowlamb::Core::QuestFactory.instance; end
  def player_factory; Ricer4::Plugins::Shadowlamb::Core::PlayerFactory.instance; end

  def data_loader; Ricer4::Plugins::Shadowlamb::Core::Loader::Datafile.instance; end
  def shadowlamb_dir; @@shadowdir ||= File.absolute_path("#{File.dirname(__FILE__)}/../.."); end
  
  def gm_name(user); "[\x02GM\x02]#{user.display_name}"; end
  def short_name; self.class.name.demodulize; end;
  def name_string; self.class.name_string; end
  def name_symbol; name_string.to_sym; end

  def get_data_file(filename); data_loader.get_data_file(filename); end

  def max_level; get_config(:max_level); end
  
  def get_action(action_name) Ricer4::Plugins::Shadowlamb::Core::Action.get_action(action_name) or raise RuntimeException.new("Unknown base#get_action: #{action_name}"); end
  def get_value_name(value_name); Ricer4::Plugins::Shadowlamb::Core::ValueName.get_value_name(value_name) or raise RuntimeException.new("Unknown base#get_value_name: #{value_name}"); end

  def get_race(race_name); Ricer4::Plugins::Shadowlamb::Core::Race.get_race(race_name) || (raise RuntimeException.new("Unknown base#get_race: #{race_name}")); end
  def get_gender(gender_name); Ricer4::Plugins::Shadowlamb::Core::Gender.get_gender(gender_name) || (raise RuntimeException.new("Unknown base#get_gender #{gender_name}")); end
  def get_profession(profession_name); Ricer4::Plugins::Shadowlamb::Core::ProfessionName.get_profession(profession_name) || (raise RuntimeException.new("Unknown base#get_profession #{profession_name}")); end

  def get_ai(ai_include); self.class.get_ai(ai_include); end;

  def clamp(value, min=nil, max=nil)
    value = min if (min != nil) && (value < min)
    value = max if (max != nil) && (value > max)
    value
  end
  
  def color_for_factor(factor, alert_from=0.5)
    return '' if factor >= alert_from
    factor *= (1 / alert_from)
    red = factor * 255
    lib.color(red, 0, 0)
  end
  
  def rune_appendix; I18n.t!('shadowlamb.rune_appendix') rescue '_of_'; end
  def comma_appendix; I18n.t!('shadowlamb.comma_appendix') rescue ', '; end

  # def human_join(array); lib.human_join(array); end
  def values_join(array); array.join(comma_appendix); end
  def display_items(items); self.class.display_items(items); end
  def display_selected_items(items); self.class.display_selected_items(items); end
  
  ##############
  ### Plugin ###
  ##############  
  def get_plugin(plugin_name); bot.loader.get_plugin(plugin_name); end
  def get_shadowlamb_plugin; get_plugin('Shadowlamb/Shadowlamb'); end
  def get_config(config_name)
    get_plugin('Shadowlamb/Shadowlamb').get_setting(config_name) rescue raise Ricer4::ExecutionException.new("Invalid Plugin Setting: #{config_name}"); 
  end

end
