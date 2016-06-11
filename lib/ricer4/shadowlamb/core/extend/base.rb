module Ricer4::Plugins::Shadowlamb::Core::Extend::Base

  def name_string; name.rsubstr_from('::').downcase; end
  def name_symbol; name_string.to_sym; end

  def bot; Ricer4::Bot.instance; end
  def shadowtime; get_config(:shadowtime); end
  def shadowverse; Ricer4::Plugins::Shadowlamb::Core::Shadowverse.instance; end
  
  def mob_factory; Ricer4::Plugins::Shadowlamb::Core::MobFactory.instance; end
  def item_factory; Ricer4::Plugins::Shadowlamb::Core::ItemFactory.instance; end
  def gift_factory; Ricer4::Plugins::Shadowlamb::Core::GiftFactory.instance; end
  def quest_factory; Ricer4::Plugins::Shadowlamb::Core::QuestFactory.instance; end
  def player_factory; Ricer4::Plugins::Shadowlamb::Core::PlayerFactory.instance; end

  def data_loader; Ricer4::Plugins::Shadowlamb::Core::Loader::Datafile.instance; end
  def get_data_file(filename); data_loader.get_data_file(filename); end
  def get_ai(ai_include); Object.const_get("Ricer4::Plugins::Shadowlamb::Core::Ai::#{ai_include.camelize}") or raise StandardError.new("Unknown base#get_ai #{ai_include}"); end
  def get_value_name(key); Ricer4::Plugins::Shadowlamb::Core::ValueName.get_value_name(key); end

  # def itemlist; @@itemlist ||= Ricer4::Plugins::Shadowlamb::Core::ItemList; end
  
  def display_items(items); (Array(items).collect{|item|item.display_name}).join(", "); end
  def display_selected_items(items); (Array(items).collect{|item|item.display_name_selected}).join(", "); end
  
#  def display_items(items); itemlist.display_items(items); end
#  def display_selected_items(items); itemlist.display_selected_items(items); end

  def get_plugin(plugin_name); bot.loader.get_plugin(plugin_name); end
  def get_shadowlamb_plugin; get_plugin('Shadowlamb/Shadowlamb'); end
  def get_config(config_name)
    get_plugin('Shadowlamb/Shadowlamb').get_setting(config_name) rescue raise Ricer4::ExecutionException.new("Invalid Plugin Setting: #{config_name}"); 
  end

end
