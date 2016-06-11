module Ricer4::Plugins::Shadowlamb::Core::Include::PartyVisibility
  
  def visible_radius
    1000 # 1000 meters
  end

  def visible_players(arg='*')
    parties_to_members(visible_parties, arg)
  end
  
  def visible_parties
    return near_parties unless is_walking?
    parties = []
    player_factory.parties.each do |them|
      if them != self
        parties.push(them) if in_visible_radius?(them)
      end
    end
    parties
  end
  
  def in_visible_radius?(them)
    true
  end
  
  def near_parties
    return [self.other_party] if is_interacting?
    parties = []
    player_factory.parties.each do |them|
      if (self.action == them.action) && (self.location == them.location)
        parties.push(them) if them != self
      end
    end
    parties
  end
  
  def near_players(arg='*', &block)
    parties_to_members(near_parties, arg, &block)
  end
  
  def parties_to_members(parties, arg='*', &block)
    players = []
    
    arg.downcase!
    arg.gsub!(/[\x00-\x1f]+/, '')
    arg.gsub!('*', "\x01")
    arg = Regexp.quote(arg)
    arg.gsub!("\x01", '.*')
    
    regex = Regexp.new(arg)
    
    parties.each{|them|them.members.each{|member|
      if block.nil? || block.call(member)
        if (member.name.downcase == arg) || (member.full_name.downcase == arg)
          players.push(member)
          return players
        elsif regex.match(member.name)
          players.push(member)
        end
      end
    }}
    players #.uniq
  end
  
end
