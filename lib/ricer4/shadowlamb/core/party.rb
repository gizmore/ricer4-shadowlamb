module Ricer4::Plugins::Shadowlamb::Core
  class Party < ActiveRecord::Base
    
    self.table_name = 'sl5_parties'
    arm_cache
    def arm_cache?
      true
      # TODO: not need to cache stationary or offline players
      # memebers.each do |member|
        # begin
          # return false if member.is_a?(StationaryNpc)
          # return true if member.user.online?
        # rescue StandardError => e
          # bot.log.exception(e)
        # end
      # end
      # false
    end
    
    LOOT_CYCLE  = 1
    LOOT_KILLER = 2
    LOOT_RANDOM = 3

    arm_events

    include Include::Base
    include Include::Dice
    include Include::Translates
    include Include::HasItems
    include Include::HasValues
    include Include::HasLocation
    include Include::PartyVisibility
    include Include::Shadowevents

    belongs_to :action,      :class_name => "Ricer4::Plugins::Shadowlamb::Core::Action"
    belongs_to :last_action, :class_name => "Ricer4::Plugins::Shadowlamb::Core::Action"
    
#    has_many :members, -> { order('sl5_players.party_updated_at ASC') }, :class_name => "Ricer4::Plugins::Shadowlamb::Core::Player"#, :autosave => false
    
    def members
      @members ||= load_members
    end
    
    def load_members
      @members = []
      Player.where(:party_id => self.id).each do |player|
        @members.push(player_factory.cast_and_load_player(player))
      end
      @members
    end
    
    has_position
    
#    has_items :loot
#    LOOT_MODES = [:killer, :cycle, :random, :ground]
    
    arm_install do |m|
      m.create_table table_name do |t|
        t.integer   :floor,          :limit => 1,  :default => 0,  :unsigned => false
        t.integer   :loot_mode,      :limit => 1,  :default => 2,  :unsigned => true
        t.integer   :loot_cycle,     :limit => 1,  :default => 0,  :unsigned => true
        t.decimal   :latitude,       :null => true, :precision => 10, :scale => 7
        t.decimal   :longitude,      :null => true, :precision => 10, :scale => 7
        t.integer   :action_id
        t.string    :target,         :limit => 32, :collation => :ascii_bin, :charset => :ascii
        t.integer   :last_action_id
        t.string    :last_target,    :limit => 32, :collation => :ascii_bin, :charset => :ascii
        t.timestamps :null => false
      end
    end
    arm_install('Ricer4::Plugins::Shadowlamb::Core::Action' => 1) do |m|
      m.add_foreign_key table_name, :sl5_actions, :name => :all_party_actions,  :column => :action_id
      m.add_foreign_key table_name, :sl5_actions, :name => :last_party_actions, :column => :last_action_id
    end
    
    ###
    def leader; members.first; end
    def membercount; members.size; end
    def is_alone?; membercount <= 1; end
    def is_leader?(player); leader.id == player.id; end
    def is_mob_party?; leader.is_mob?; end
    
    ##############
    ### Events ###
    ##############
    after_initialize :register_events
    def register_events
      bot.log.debug("Party.register_events()")
      arm_subscribe('party/moved', self) do; moved; end
    end
    
    ###############
    ### Display ###
    ###############
    def display_action
      action_klass.display_action(self)
    end

    def display_debug
      loct = location.display_name rescue ""
      area = area.display_name rescue ""
      cord = display_coordinates rescue ""
      "Party_of_#{display_members}@#{cord}_in_#{loct}/#{area}"
    end

    def display_members
      return "{NONE}" if members.nil? || members.empty?
      out = []
      members.each do |member|
        out.push(member.full_name)
      end
      human_join(out)
    end
    
    def display_combat_members
      out = []
      members.each do |member|
        out.push(member.combat_stack.display_player)
      end
      human_join(out)
    end
    
    def display_loot_mode
      case self.loot_mode
      when LOOT_CYCLE; t!(:loot_cycle) rescue "cycle"
      when LOOT_KILLER; t!(:loot_cycle) rescue "killer"
      when LOOT_RANDOM; t!(:loot_cycle) rescue "random"
      end
    end
    
    ################
    ### DB Stuff ###
    ################
    def floor; self[:floor]; end
    
    def save_party!
      unless (membercount == 0) || (is_mob_party?)
        self.save! if self.changed?
        save_players!
      end
      self
    end

    def save_players!
      members.each{|member| member.save_player! if member.changed? }
      self
    end
    
    def destroy_party!
      bot.log.debug("party#destroy_party! #{self.display_members}")
      player_factory.remove_party(self)
      self.destroy_players!
      self.destroy!
      nil
    end
    
    def destroy_players!
      bot.log.debug("party#destroy_players! #{self.display_members}")
      members.each do |member|
        member.destroy_player!
      end
      @members = nil
      nil
    end
    
    def add_member(player)
      @members ||= []
      members.push(player)
      player.party, player.party_updated_at = self, Time.now
      self
    end
    
    def remove_member(player)
      members.delete(player)
      self.destroy_party! if membercount == 0
      self
    end
    
    def clean_dead_members
      members.each do |member|
        if member.dead?
          member.respawn!
        end
      end
    end
    
    def offset_for(player)
      offset = 1
      members.each do |member|
        return offset if member == player
        offset += 1
      end
      0
    end

    #################
    ### Messaging ###
    #################
    def send_message(key, &block)
      members.each do |member|
        member.localize!.send_message(t(key, block.call))
      end
    end
    
    def send_message_for(player, key, args={})
      args[0] = {} if args[0].nil?; args[0][:player] = player
      members.each do |member|
        if member == player
          member.localize!.send_message(t("#{key}_self", localized_args(args)))
        else
          member.localize!.send_message(t("#{key}_party", localized_args(args)))
        end
      end
    end
    
    def send_message_with_busy(player, key, args={})
      return send_message_for(player, key, args) unless is_fighting?
      args[0] = {} if args[0].nil?; args[0][:player] = player
      members.each do |member|
        if member == player
          member.localize!.send_message(t("#{key}_self", localized_args(args))+player.busy_text)
        else
          member.localize!.send_message(t("#{key}_party", localized_args(args))+player.busy_text)
        end
      end
    end
    
    # def send_message_except(player, key, args={})
      # args[0] = {} if args[0].nil?; args[0][:player] = player
      # members.each do |member|
        # if member != player
          # member.localize!.send_message(t("#{key}_party", localized_args(args)))
        # end
      # end
    # end
# 
    # def send_message_busy_except(player, key, args={})
      # return send_message_except(player, key, args) unless is_fighting?
      # args[0] = {} if args[0].nil?; args[0][:player] = player
      # members.each do |member|
        # if member != player
          # member.localize!.send_message(t("#{key}_party", localized_args(args))+player.busy_text)
        # end
      # end
    # end
# 
    # def send_both_message_with_busy(player, key, args={})
      # self.send_message_with_busy(player, key, args)
      # self.other_party.send_message_with_busy(player, key, args)
    # end
#     
    # def localized_args(args={})
      # back = {}
      # args.each do |key, arg|
        # back[key] = arg.display_name rescue arg
      # end
      # back
    # end
    
    ###########################
    ### Fix for mob parties ###
    ###########################
    arm_subscribe('party/stopped/fighting') do |sender, party|
      party.destroy_party! if party.is_mob_party? || (party.dead?)
    end
    
    ##################
    ### Publishing ###
    ##################    
    def publish_party_and_members(event_group, event_name, *event_args)
      publish_members(event_group, event_name, *event_args)
      publish_party(event_group, event_name, *event_args)
    end
    
    def publish_party(event_group, event_name, *event_args)
      arm_publish("party/#{event_group}/#{event_name}", self, *event_args)
    end

    def publish_members(event_group, event_name, *event_args)
      members.each{|member|arm_publish("player/#{event_group}/#{event_name}", member, *event_args)}
    end    

    ###############
    ### Actions ###
    ###############
    def action_sym; self.action.name; end
    def action_klass; Action.get_action(action.name); end
    def target_object; @target_object ||= action_klass.target_object(self); end
    
    def was?(*action_sym)
      #Array(action_sym).include?(last_action.name.to_sym)
      action_sym.include?(last_action.name.to_sym)
    end
    
    def push_action(action_sym, target=nil)
      
      new_action = get_action(action_sym)
      new_target = new_action.target_id(self, target)
      
      # Nothing changed
      # XXX: We catch that with de-duplicate below
#      raise StandardError.new("Party shall push a duplicate state.") if (new_action == self.action) && (new_target == self.target) 
      
      begin
        
        #if fire_events # Trigger events
          publish_party_and_members('changing', 'action', self.action, new_action) # changing old to new
          publish_party_and_members('stopping', self.action.name) # stopping old
          publish_party_and_members('starting', new_action.name)      # starting new
        #end
        
        ### Push it / Swap it
        self.last_action, self.last_target, self.action, self.target, @target_object = 
             self.action, self.target,      new_action,  new_target,  target
        bot.log.debug("party with '#{self.display_members}' changed from #{self.last_action.name} #{self.last_target} to #{self.action.name} target is #{self.target}")

        #if fire_events # Trigger events
          publish_party_and_members('started', self.action.name)       # started new 
          publish_party_and_members('stopped', self.last_action.name)  # stopped old
          publish_party_and_members('changed', 'action', self.last_action, self.action) # changed old to new
        #end
              
      rescue Ricer4::SilentCancelException
        bot.log.debug("party#push_action => SilentCancelException")
        raise
      end

      self
    end
    
    def pop_action
      bot.log.debug("Party#pop_action for #{self.display_members}")
      fix_pop_recursion
      begin
        publish_party_and_members('continue', self.last_action.name)
        push_action(self.last_action.name, self.last_target)
        publish_party_and_members('continued', self.action.name)
        unless self.action.continue_message(self).nil?
          members.each do |member|
            member.localize!.send_message(self.action.continue_message(self))
          end
        end
      end
    end

    def fix_pop_recursion
      self.last_action, self.last_target = get_action(:outside), nil if pop_recursion?
    end

    def pop_recursion?
      (self.action == self.last_action) && (self.target == self.last_target)
    end
    
    def action_is?(action_name); action.name == action_name.to_s; end
    def action_in?(*action_syms); action_syms.include?(action.name.to_sym); end
    def is_sleeping?; action_is?(:sleeping); end
    def is_idle?; action_in?(:inside, :outside, :knocking); end
    def is_dead?; action_in?(:created, :spawning); end
    def is_moving?; action_in?(:move, :goto, :explore, :travel, :beam_to, :beam_into); end
    def is_walking?; action_in?(:move, :goto, :explore); end
    def is_travelling?; action_is?(:travel); end
    def is_inside?; action_is?(:inside); end
    def is_outside?; action_is?(:outside); end
    def is_knocking?; action_is?(:knocking); end
    def is_talking?; action_is?(:talking); end
    def is_fighting?; action_is?(:fighting); end
    def is_fighting_mobs?; is_fighting? && (target[0] == '#'); end
    def is_interacting?; action_in?(:talking, :fighting); end
    def is_active?; action_in?(:beam_into, :beam_to, :explore, :goto, :move, :talking, :sleeping, :fighting, :travel); end
    def can_interrupt?; action_in?(:beam_into, :beam_to, :explore, :goto, :inside, :move, :outside, :knocking, :talking); end
    
    def execute_action(elapsed)
      return if elapsed.nil?
      begin
#        bot.log.debug("Party#execute_action for #{self.display_members} after #{elapsed} seconds.")
        publish_party_and_members('before', 'action', elapsed)
        publish_party_and_members('before', self.action.name, elapsed)
        action_klass.execute_action(self, elapsed)
        publish_party_and_members('after', 'action', elapsed)
        publish_party_and_members('after', self.action.name, elapsed)
      rescue PartyGone
        bot.log.debug("Party#execute_action for #{self.display_members}: party is gone!")
        pop_action
      rescue Ricer4::SilentCancelException
        bot.log.debug("Party#execute_action for #{self.display_members}: silently cancelled.")
      end
      self
    end
    
    ##############
    ### Combat ###
    ##############
    def ground; @ground || new_ground; end
    def new_ground; @ground = Ground.new(self); end
    def dead?; members.select{|member|!member.dead?}.length == 0; end
    
    ###################
    ### Other Party ###
    ###################
    def other_party
      raise StandardError.new("party#other_party: Not interacting with action #{action.name}") unless is_interacting?
      target_party
    end    

    def enemy_party
      raise StandardError.new("party#enemy_party: Not fighting but has action #{action.name}") unless is_fighting?
      target_party
    end
    
    def target_party
      begin
        target_object
      rescue PartyGone => e
        pop_action
      end
    end    
    
    ################
    ### Location ###
    ################
    def area
      @area ||= detect_area
    end
    def area=(area)
      @area = area
    end
    def detect_area
      shadowverse.locate_area(self)
    end
    
    def location
      @location == false ? false : @location ||= detect_location
    end
    def location=(location)
      @location = location
    end
    def detect_location
      shadowverse.locate_location(self)
    end
    
    #################
    ### Interrupt ###
    #################
    ### Interrupts whatever the party is doing (possibly)
    def interrupt!(action_will_be=:fighting)
      action_will_be = get_action(action_will_be) unless action_will_be.nil? # Test valid action
      return self if action == action_will_be # No need to interrupt
      raise Ricer4::ExecutionException.new("Cannot interrupt party action: #{action.name}") unless can_interrupt?
      if is_moving?
        push_action(:outside)
      elsif is_interacting?
        pop_action
      end 
      self
    end
    
    ################
    ### MOVEMENT ###
    ################
    def stop!
      push_action(:outside)
      send_message("ricer.plugins.shadowlamb.stop.msg_stopped")
    end
    
    def raise_floor(by)
      self.floor += by
      self.save!
      self.moved
      self.push_action(:knocking)
    end

    def set_lat_lon(lat, lon)
      bot.log.debug("Set party #{self.display_members} to #{lat.round(6)},#{lon.round(6)}")
      self.latitude, self.longitude = lat, lon
    end

    def coordinates
      Ricer4::Plugins::Shadowlamb::Core::Coordinate.new(lat, lon)
    end
    
    def moved
      bot.log.debug("Party.moved() PartyID: #{self.id}")

      # Calc area/location
      party = self
      old_area, old_location = party.area, party.location
      new_area, new_location = party.detect_area, party.detect_location
      bot.log.debug("Area was #{old_area.display_name} and is now #{new_area.display_name}.")
      bot.log.debug("Location was #{old_location ? old_location.display_name : 'nil'} and is now #{new_location ? new_location.display_name : 'nil'}.")
      
      # React on area change
      if old_area != new_area
        byebug
        if !old_area.sl5_can_exit_area?(party, old_area, new_area) || !new_area.sl5_can_enter_area?(party, old_area, new_area)
          # Reached area border!
          byebug
          raise Ricer4::SilentCancel.new("cannot switch area")
        else
          party_changes_area(party, old_area, new_area)
        end
      end
      if old_location != new_location
        party_changes_location(party, old_location, new_location)
      end
    end
    
    def clamp_to_area(area)
      set_lat_lon(latitude.clamp(area.minlat, area.maxlat), longitude.clamp(area.minlon, area.maxlon))
    end
    
    ###
    ### Make the party change the location and fire events
    ###
    def party_changes_location(party, old_location, new_location)
      if old_location
        arm_publish("party/leaves/location", party, old_location, new_location)
      end
      if new_location
        party.location, party.area = new_location, new_location.area
        arm_publish("party/reaches/location", party, old_location, new_location)
      else
        party.location = false
      end
    end

    def party_changes_area(party, old_area, new_area)
      arm_publish("party/leaves/area", party, old_area, new_area)
      party.area = new_area
      send_message("shadowlamb.msg_entered_area", area: new_area.display_name)
      arm_publish("party/enters/area", party, old_area, new_area)
    end

  end
end
