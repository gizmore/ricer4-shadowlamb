module Ricer4::Plugins::Shadowlamb::Core
  class CombatStack
    
    MIN_BUSY = 20
    MAX_BUSY = 90
    
    include Include::Base
    include Include::Dice
    include Include::Translates
    arm_events
    
    def self.clear_combat_stack(party)
      party.members.each{|member|member.combat_stack.clear_combat_stack}
    end

    arm_subscribe('party/starting/fighting') do |sender, party|
#      party.send_message("shadowlamb.msg_encounter", enemies: party.display_members)
      clear_combat_stack(party)
    end
    
    arm_subscribe('party/stopped/fighting') do |sender, party|
      clear_combat_stack(party)
#      party.send_message("shadowlamb.msg_encounter", enemies: party.display_members)
    end

    # arm_subscribe('player/starting/fighting') do |sender, player|
      # bot.log.debug("CombatStack event player/starting/fighting for #{player.display_name}")
      # player.combat_stack.clear_combat_stack
    # end
    
    # arm_subscribe('player/stopped/fighting') do |sender, player|
      # bot.log.debug("CombatStack event player/stopped/fighting for #{player.display_name}")
      # player.combat_stack.clear_combat_stack
      # # party.members.each do |member|
        # # if member.combat_stack.busy?
          # # raise Ricer4::SilentCancelException.new("Won´t stop yet!") 
        # # end
      # # end
    # end
    
    arm_subscribe('player/after/fighting') do |sender, player, elapsed|
#      bot.log.debug("CombatStack: player/after/fighting #{elapsed} elapsed")
      stack = player.combat_stack
      stack.combat_command! unless stack.busy?
    end
    
    def initialize(player)
      @player = player
      clear_combat_stack
    end
    
    def party
      @player.party
    end
    
    def clear_combat_stack
      @busy = 0
      @distance = 2
      @command = nil
      @cmdlock = false
      @target = nil
      @x = party.offset_for(@player)
      @y = 2
    end
    
    def display_player
      "#{@x}–#{@player.player_name}"
    end
    
    def default_command
      get_plugin('Shadowlamb/Attack').execute_attack(@player, @target||random_enemy)
    end
    
    def target_valid?
      (@target.party == @player.party) || 
      (@target.party.enemy_party == @player.party)
    end
    
    def invalidate_target
      begin
        return if target_valid?
      rescue StandardError => e
      end
      @target, @command, @lock = nil, nil, nil
    end
    
    def random_enemy
      party.enemy_party.members.sample
    end
    
    
    # def combat_target
      # valid_combat_target(locked_combat_target)
    # end
    
    # def locked_combat_target
      # @target ||= sl5_random_combat_target
    # end
    
    # def valid_combat_target(target)
      # enemy_party.has_member?(target) || random_combat_target or
        # raise Ricer4::Plugins::Shadowlamb::Core::TargetGone.new("NO TARGET!")
    # end
    
    # def random_combat_target
      # enemy_party.members.sample
    # end

    def combat_command=(proc)
      @command = proc
    end
    
    def combat_target=(target)
      @target = target
    end

    def combat_command_lock=(lock)
      @cmdlock = lock
    end
    
    def combat_command!
      bot.log.debug("CombatStack#combat_command! for #{@player.display_name}")
      invalidate_target
      return default_command if @command.nil?
      @command.call
      @command = nil unless @cmdlock
    end
    
    ############
    ### Busy ###
    ############
    def random_busy
      busy(random_busy_time)
    end
    
    def random_busy_time
      dice_against_max_values(@player, {:quickness => 100, :luck => 100}, MAX_BUSY, MIN_BUSY) + rand(0, 30)
    end

    def busy(seconds)
      @busy = [@busy+seconds, 0].max.to_i
      bot.log.debug("Setting #{@player.display_name} #{@busy} busy")
    end
    
    def busy?
      bot.log.debug("#{@player.display_name} is busy: #{@busy}") if @busy > 0
      bot.log.debug("#{@player.display_name} is not busy.") if @busy == 0
      @busy > 0
    end
    
    def busy_seconds
      @busy
    end
    
    def busy_text
      return '' if @busy <= 0
      ' ' + t(:busytext, duration: busy_seconds)
    end
  
  end
end
