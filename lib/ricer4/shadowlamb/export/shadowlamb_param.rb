load File.expand_path("../parse_param_relation.rb", __FILE__)
class ActiveRecord::Magic::Param::ShadowlambParam < Ricer4::Parameter
  
  include Ricer4::Plugins::Shadowlamb::Core::Include::ParseParamRelation
  
  def own_player
    byebug
    sender.instance_variable_get(:@sl5_player)
  end

  def own_party
    own_player.party
  end

  def parse_item_param(input, items)
    input.downcase!
    amount = parse_amount(input)
    item = parse_param_relation(items, input)
    item.selected_amount = amount
    item
  end
  
  def parse_amount(input)
    if match = input.match("(\\d+)x(.+)")
      input.replace(match[2])
      match[1].to_i
    else
      1
    end
  end

end
