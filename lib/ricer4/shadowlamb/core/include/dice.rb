module Ricer4::Plugins::Shadowlamb::Core::Include::Dice
  
  def rand(min, max)
    bot.rand.rand(min..max)
  end
  
  def dice_against_percent(min)
    rand(0, 10000) >= ((min*100).to_i)
  end
  
  def dice_percent(min=0, max=100)
    rand(min, max) * 100 # 0-10000
  end

  def dice_percent_f(min=0, max=100)
    rand(min.to_f, max.to_f) / 100.0 # 0.0 - 1.0
  end

  #
  # Attack/Defense between 0 and 1
  # This is just the first intital "how good were you, eh?"
  # There is luck involved, and "sharpshooter"
  #  
  def dice_attack_percent(player)
    min_bonus = # Add it to both
      player.get_adjusted_fmul(:luck, 10) + # +10% for luck
      player.get_adjusted_i(:sharpshooter, 20) # +20% for sharpshooter
    min = 50 + min_bonus
    max = 100 + min_bonus
    dice_percent_f(min, max)
  end
  def dice_defend_percent(player)
    min_bonus = # Add it to both
      player.get_adjusted_fmul(:luck, 10) # +10% for luck
    min = 10 + min_bonus
    max = 70 + min_bonus
    dice_percent_f(min, max)
  end
  
  def dice_critical_attack(player)
  end
  
  def dice_critical_defend(player)
    rand(1)
  end

  def dice_hit
    rand(0, 1) == 0
  end
  
  def dice_item_value(value)
    if value.is_a?(Array)
      if is_gaussian?(value)
        dice_gauss(value[0], value[1])
      else
        value.sample
      end
    else
      value
    end
  end
  
  def is_gaussian?(value_array)
    return false if value_array.count != 2
    value_array.each do |value|
      return false unless value.numeric?
    end
    true
  end
  
  def dice_gauss(min, max)
    rand(min, max)
  end
  
  ######################
  ### Dice with gmi% ###
  ######################
  ### 
  # def dice_parse_all_off(gmi_string)
    # return [] if gmi_string.nil? || gmi_string.empty?
    # gmi_string = gmi_string.split(',') if gmi_string.is_a?(String)
    # gmi_string.map! do |s|; s.substr_from('%') || s; end
    # gmi_string
  # end
  # def dice_one_of!(gmi_string)
    # return nil if gmi_string.nil? || gmi_string.empty?
    # gmi_string = gmi_string.split(',') if gmi_string.is_a?(String)
    # chances = {}
  # end
  def dice_one_of(gmi_string)
    # empty is fine
    return nil if gmi_string.nil? || gmi_string.empty?
    # split by ,
    gmi_string = gmi_string.split(',') if gmi_string.is_a?(String)
    # Sum percents and total
    percents, total = [], 0
    gmi_string.map do |s|
      percent = ((s.nibble!('%').to_f)*100).to_i rescue 10000
      percents.push(percent); total += percent
    end
    # when sum below 100%, add nil to fill 100%
    if total < 10000
      gmi_string.push(nil); total += 10000 - total; percents.push(10000 - total)
    end
    
    diced = rand(0, 10000)
    normal = 10000 / total # Normalize to 0-100%
    percents.each_with_index do |p, i|
      return gmi_string[i] if diced < ((p * normal).to_i)
    end
    return nil
  end

  def dice_multiple_of(gmi_string)
    # empty is fine
    return nil if gmi_string.nil? || gmi_string.empty?
    # split by ,
    gmi_string = gmi_string.split(',') if gmi_string.is_a?(String)
    gmi_string.select do |s|
      percent = ((s.substr_to('%').to_f)*100).to_i rescue 10000
      rand(0, 10000) < percent
    end
  end
  
  ###############################
  ### Dice against max values ###
  ###############################
  ### Example: dice_against_max_values(player, {quickness:100, strength:50}, 0, 100)
  ###
  def dice_against_max_values(player, value_weight_hash, low, high)
    if low > high
      high - _dice_against_max_values(player, value_weight_hash, high, low)
    else
      _dice_against_max_values(player, value_weight_hash, low, high)
    end
  end
  
  def _dice_against_max_values(player, value_weight_hash, low, high)
    range, have, total = high-low, 0, 0
    value_weight_hash.each do |key, percent|
      have = (player.get_adjusted(key) * percent / 100).to_i
      total += (player.get_adjusted_max(key) * percent / 100).to_i
    end
    percent = have/total
    low += range * percent
    rand(low, high)
  end
  
end
