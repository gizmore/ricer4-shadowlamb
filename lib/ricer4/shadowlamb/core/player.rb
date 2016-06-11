module Ricer4::Plugins::Shadowlamb::Core
  class Player < ActiveRecord::Base
      
    self.table_name = 'sl5_players'
    
    arm_cache
    def arm_cache?; !is_abstract?; end #user.nil? || user.online; end

    def self.dont_store_values; true; end

    arm_events
    include Include::Base
    include Include::Dice
    include Include::Translates
    include Include::HasValues
    include Include::HasItems
    include Include::Spawns

    belongs_to :user, :class_name => 'Ricer4::User'
 
    belongs_to :party, :class_name => 'Ricer4::Plugins::Shadowlamb::Core::Party' 
    
    scope :npc, -> { where("#{table_name}.user_id IS NULL") }
    scope :human, -> { where("#{table_name}.user_id IS NOT NULL") }
    scope :runner, -> { where("#{table_name}.runner=1") }
    scope :newbie, -> { where("#{table_name}.runner=0") }
    
    belongs_to :race,    :class_name => "Ricer4::Plugins::Shadowlamb::Core::Race"
    belongs_to :gender,  :class_name => "Ricer4::Plugins::Shadowlamb::Core::Gender"
    
    has_many :professions, :class_name => "Ricer4::Plugins::Shadowlamb::Core::Profession", :autosave => true, :dependent => :destroy
    has_many :knowledges,  :class_name => "Ricer4::Plugins::Shadowlamb::Core::Knowledge", :autosave => true, :dependent => :destroy

    has_many :known_words, :class_name => "Ricer4::Plugins::Shadowlamb::Core::Word", :through => :knowledges, :source => :knowledge, :source_type => "Ricer4::Plugins::Shadowlamb::Core::Word"
    has_many :known_places, :class_name => "Ricer4::Plugins::Shadowlamb::Core::Location", :through => :knowledges, :source => :knowledge, :source_type => "Ricer4::Plugins::Shadowlamb::Core::Location"

    has_one  :feeling, :class_name => "Ricer4::Plugins::Shadowlamb::Core::Feeling", :autosave => true, :dependent => :destroy
    has_one  :levelup, :class_name => "Ricer4::Plugins::Shadowlamb::Core::Levelup", :as => :owner, :autosave => true, :dependent => :destroy
    has_many :effects, :class_name => "Ricer4::Plugins::Shadowlamb::Core::Effect", :autosave => true, :dependent => :destroy
    
    has_items :bank
    has_items :mount
    has_items :equipment, :class_name => "Ricer4::Plugins::Shadowlamb::Core::EquipmentList"
    has_items :inventory
    has_items :cyberware
    
    has_many :missions, :class_name => "Ricer4::Plugins::Shadowlamb::Core::Mission", :dependent => :destroy
    has_many :quests, :through => :missions, :source => :quest, :source_type => "Ricer4::Plugins::Shadowlamb::Quest"
    
    delegate :is_alone?, :is_fighting?, :action_is?, :location, :area, :target_object, :other_party, :enemy_party, :to => :party
    
    arm_install do |m|
      m.create_table table_name do |t|
        t.integer   :npc_id,     :null => true,  :default => nil
        t.integer   :user_id,    :null => true,  :default => nil
        t.integer   :race_id,    :null => false
        t.integer   :gender_id,  :null => false
        t.integer   :party_id,   :null => true
        t.boolean   :runner,     :null => true,  :default => nil
        t.string    :playername, :null => true,  :default => nil, :limit => 48
        t.timestamp :party_updated_at, :null => true
        t.timestamps :null => false
      end
    end
    arm_install('Ricer4::User' => 1, 'Ricer4::Plugins::Shadowlamb::Core::NpcName' => 1, 'Ricer4::Plugins::Shadowlamb::Core::Race' => 1, 'Ricer4::Plugins::Shadowlamb::Core::Gender' => 1, 'Ricer4::Plugins::Shadowlamb::Core::Party' => 1) do |m|
      m.add_index       table_name, :party_id,    :name => :player_party
      m.add_foreign_key table_name, :ricer_users,   :name => :player_users,   :column => :user_id
      m.add_foreign_key table_name, :sl5_npcs,    :name => :player_npcs,    :column => :npc_id
      m.add_foreign_key table_name, :sl5_races,   :name => :player_races,   :column => :race_id
      m.add_foreign_key table_name, :sl5_genders, :name => :player_genders, :column => :gender_id
      m.add_foreign_key table_name, :sl5_parties, :name => :player_parties, :column => :party_id
    end
    
    def name; self.user.name; end
    def full_name; "#{self.user.name}:#{self.user.server_id}"; end
    def player_name; self.user.display_name; end
    def is_leader?; self.party.is_leader?(self); end
    def is_runner?; self.runner; end
    
    def is_human?; false; end
    def is_npc?; false; end
    def is_mob?; false; end
    def is_real_npc?; false; end
    def is_abstract?; true; end
    def is_stationary?; false; end
    
    def refresh_ricer_user
#      self.user = Ricer4::User.cached_by_id(self.user_id)
      self.user.instance_variable_set(:@sl5_player, self)
    end
    
    #################
    ### Equipment ###
    #################
    def equipped(slot); equipment.items.each do |item|; return item if item.equipment_slot == slot; end; nil; end
    def equipped_i18n(arg)
      arg = arg.downcase
      equipment.items.each do |item|
        if ((item.equipment_slot_short.downcase == arg) ||
            (item.equipment_slot_long.downcase == arg) ||
            (item.equipment_slot.to_s == arg))
          return item 
        end
      end
      nil
    end
    
    def has_max_equipped?(slot)
      has_equipped?(slot)
    end
    def has_equipped?(slot); equipped(slot) != nil;  end
    def has_weapon?; equipped(:weapon) != nil; end
    def weapon; equipped(:weapon)||fists; end
    def fists; @fists ||= _fists; end
    def _fists; @fists = get_item('Fists'); @fists.owner = self; @fists; end
    
    #################
    ### Inventory ###
    #################
    def give_item(item); give_items(Array(item)); end
    def give_items(items)
      inventory.add_items(items)
      party.send_message_except(self, :msg_player_looted, items: display_items(items))
    end

    ##############
    ### Action ###
    ##############
    def action; party.action_object; end

    ##############
    ### Combat ###
    ##############
    delegate :busy, :busy?, :busy_text, :busy_seconds,
      :combat_command=, :combat_command_lock=, :combat_target=, :combat_command!, 
      :to => :combat_stack
    def combat_stack; @combat_stack ||= CombatStack.new(self); end
#    def new_combat_stack; @combat_stack = CombatStack.new(self); end
    def respawn!
      old_party, new_party = self.party, clone_party(party)
      new_party.push_action(:outside)
      new_party.push_action(:spawning)
      transaction do 
        new_party.add_member(self)
        old_party.remove_member(self)
        old_party.save_party!
        new_party.save_party!
      end
      self
    end
    
    ##############
    ### Moving ###
    ##############
    def near_parties; party.near_parties; end
    def visible_parties; party.visible_parties; end
    def near_players; append_friends_to(party.near_players); end
    def visible_players; append_friends_to(party.visible_players);end
    def party_friends; party.members.select{|member|member!=self};end
    def append_friends_to(players); party_friends.each{|friend|players.push(friend)}; players; end
    # def reachable_by?(party)
      # self.party.reachable_by?(party)
    # end
    
    #################
    ### Knowledge ###
    #################
    def knows?(knowledge)
      knowledges.each do |k|
        return true if k.knowledge == knowledge
      end
      false
    end
    
    #################
    ### Messaging ###
    #################
    def localize!; user.localize!; self; end
    def send_message(text); user.send_message(text); end
    def send_msg(key, args={}); send_message(t(key, args)); end
    
    ###############
    ### Display ###
    ###############
    def runner_text; t(:runner); end
    def profession_level; professions.count; end
    def profession_texts; ["Newbie"]; end
    
    def display_name
      user.display_name
    end
    
    def displayinfo
      display_title
    end
    
    def display_title
      text = profession_texts[profession_level]
      text += " #{runner_text}" if is_runner?
      text
    end

    def display_hp
      color = color_for_factor(hp / max_hp)
      color + t(:hp_status, hp: hp, max_hp: max_hp) + color
    end

    def display_mp
      color = color_for_factor(hp / max_hp)
      color + t(:mp_status, mp: mp, max_mp: max_mp) + color
    end
    
    ####################
    ### Lose on kill ###
    ####################
    def sl5_on_killed_xp(killer, victim, with)
      if killer.is_mob?; take_xp(10)
      elsif killer.is_human?; take_xp(100)
      elsif killer.is_realnpc?; take_xp(100)
      elsif killer.is_stationary?; take_xp(100)
      end
    end
    
    def sl5_on_killed_nuyen(killer, victim, with)
      percent = 5.0
      if killer.is_mob?; percent = 2.0
      elsif killer.is_human?; percent = 10.0
      elsif killer.is_realnpc?; percent = 15.0
      elsif killer.is_stationary?; percent = 20.0
      end
      take_nuyen((nuyen*percent/100).to_i)
    end
    
    def sl5_on_killed_items(killer, victim, with)
      return victim.sl5_is_loot_protected?(killer, victim) ? [] :  
        sl5_on_killed_equipment(killer, victim, with) + 
        sl5_on_killed_inventory(killer, victim, with)
        #sl5_on_killed_loot(killer, victim, with)
    end
    def sl5_on_killed_loot(killer, victim, with); []; end
    def sl5_on_killed_equipment(killer, victim, with)
      []
    end
    def sl5_on_killed_inventory(killer, victim, with)
      []
    end

    def sl5_is_kill_protected?(killer, victim)
      false
    end
    
    def sl5_is_loot_protected?(killer, victim)
      false
    end
    
    ####################
    ### Saved Values ###
    ####################
    def dead?; hp <= 0; end
    def hp; levelup.get_bonus(:hp); end
    def mp; levelup.get_bonus(:mp); end
    def max_hp; get_adjusted(:max_hp); end
    def max_mp; get_base(:magic) <= 0 ? 0 : get_adjusted(:max_mp); end
    def add_hp(value); add_hp_mp(:hp, value, max_hp); end
    def add_mp(value); add_hp_mp(:mp, value, max_mp); end
    def add_hp_mp(key, value, max); add_levelup_bonus(key, value, 0, max); end
    
    ### Levelup auto modifies
    def add_levelup_base(key, value, min=0, max=nil)
      levelup.add_base_clamped(key, value, min, max)
      add_base_clamped(key, value, min, max)
    end
    def add_levelup_bonus(key, value, min=0, max=nil)
      levelup.add_bonus_clamped(key, value, min, max)
      add_bonus_clamped(key, value, min, max)
    end

    ### Feelings all have 0 - 10000 fixed point intensity
    def get_feeling(key); self.get_bonus(key); end
    def set_feeling(key, value)
      feeling.set_bonus_clamped(key, value, 0, 10000)
      set_bonus_clamped(key, value, 0, 10000)
    end
    def add_feeling(key, value)
      feeling.add_bonus_clamped(key, value, 0, 10000)
      add_bonus_clamped(key, value, 0, 10000)
    end
    ### Effects are simpler
    def has_effect?(key); get_effect(key) > 0; end
    def get_effect(key); self.get_bonus(key); end
    def add_effect(key, value)
      effect.add_bonus_clamped(key, value)
      add_bonus_clamped(key, value)
    end
    
    ### Wealth is xp, karma, nuyen stored in lvlup
    ### base is "available", bonus is "spent" and adjusted "total-collected"
    def get_wealth(key); get_base(key); end
    def get_spent(key); get_bonus(key); end
    def get_earned(key); get_adjusted(key); end
    def give_wealth(key, value); add_levelup_base(key, value); end
    def take_wealth(key, value); add_levelup_base(key, -value); add_levelup_bonus(key, value); end
    
    def xp; get_wealth(:xp); end
    def xp_earned; get_earned(:xp); end
    def give_xp(value); give_wealth(:xp, value); end
    def take_xp(value); take_wealth(:xp, value); end

    def karma; get_wealth(:karma); end
    def karma_earned; get_earned(:karma); end
    def give_karma(value); give_wealth(:karma, value); end
    def take_karma(value); take_wealth(:karma, value); end

    def nuyen; get_wealth(:nuyen); end
    def nuyen_earned; get_earned(:nuyen); end
    def give_nuyen(value); give_wealth(:nuyen, value); end
    def take_nuyen(value); take_wealth(:nuyen, value); end
    
    ###
    ### Adjusted with respect to max
    ### Example:
    ### get_adjusted_max (sharpshooter) => 20
    ### get_adjusted_i(:sharpshooter)
    ###
    def get_adjusted_min(key); get_value_name(key).min_adjusted; end
    def get_adjusted_max(key); get_value_name(key).max_adjusted; end
    def get_adjusted_i(key); clamp(get_adjusted(key), get_adjusted_min(key), get_adjusted_max(key)); end
    def get_adjusted_f(key); get_adjusted_i(key) / get_adjusted_max(key) rescue 0; end
    def get_adjusted_fmul(key, mul); (get_adjusted_f(key) * mul).to_i; end
    def get_adjusted_percent(key); get_adjusted(key) / get_adjusted_max(key); end
    
    ################
    ### DB Stuff ###
    ################
    def build_player_values
      self.bank = ItemList.new({list_name: 'bank', owner: self})
      self.mount = ItemList.new({list_name: 'mount', owner: self})
      self.cyberware = ItemList.new({list_name: 'cyberware', owner: self})
      self.equipment = EquipmentList.new({list_name: 'equipment', owner: self})
      self.inventory = ItemList.new({list_name: 'inventory', owner: self})
      self.levelup = Levelup.new({owner: self})
      self.feeling = Feeling.new({player: self})
      self
    end
    
    def save_player!
      self.save! if changed?
      self
#      [self.bank, self.mount, self.equipment, self.inventory].each do |item_list|
#        if item_list.changed?
#        end
#      end
#      self.bank.save!
#      self.mount.save!
#      self.equipment.save!
#      self.inventory.save!
    end

    def destroy_player!
      self.user.remove_instance_variable(:@sl5_player) if self.user && self.user.instance_variable_defined?(:@sl5_player)
      player_factory.remove_human(self)
      self.destroy!
      party.remove_member(self)
    end
    
    # ----------
    # Modify takes all values a player is affected by and applies them.
    # First we add all possible value_names with their default.
    # Then we apply in this order:
    # 1.race, 2.gender, 3.feelings, 4.lvlup, 5.profession, 6.effects, 7.cyberware, 8.equipment
    # When all these values are applied, we call the "apply_to" function for each value_name
    # These can additionally alter the character, like computing the max_carry or travel_speed
    # ---------
    def modify
#      shadowverse.mutex.synchronize do
        # Apply all existing value_names with their default values
        ValueName.all_values.each do |name, value|
          set_base(value.name, value.default)
          set_bonus(value.name, 0)
        end
        # 1-8
        modify_values(race.values)   # 1. race
        modify_values(gender.values) # 2. gender
        modify_values(feeling.values)  # 3. feelings
        modify_values(levelup.values)  # 4. levelups
        self.professions.each do |profession|; modify_values(profession.values); end  # 5. professions
        self.effects.each do |effect|; modify_values(effect.values); end # 6. effects
        self.cyberware.items.each do |item|; modify_values(item.values); end # 7. cyberware
        self.equipment.items.each do |item|; modify_values(item.values); end # 8. equipment
        # Apply all the value_names#apply function
        values.each do |value|
          value.apply_to(self)
        end
        clamp_hp.clamp_mp
#      end
    end
    
    def refresh
      add_hp(max_hp)
      add_mp(max_mp)
      bot.log.debug("Refreshed player #{self.display_name}. HP: #{self.hp}/#{self.max_hp} / #{self.mp}/#{self.max_mp}")
      self
    end
    
    def clamp_hp
      hp, max_hp = self.hp, self.max_hp
      set_bonus_clamped(:hp, hp, 0, max_hp)
      levelup.set_bonus_clamped(:hp, hp, 0, max_hp)
      self
    end
    
    def clamp_mp
      mp, max_mp = self.mp, self.max_mp
      set_bonus_clamped(:mp, mp, 0, max_mp)
      levelup.set_bonus_clamped(:mp, mp, 0, max_mp)
      self      
    end
    
    def modify_values(values)
      values.each do |value|; modify_value(value); end
    end
    
    def modify_value(value)
      add_base(value.value_key, value.base_value)
      add_bonus(value.value_key, value.bonus_value)
      bot.log.debug("#{self.display_name} - modify_value #{value.value_key}: #{value.base_value}(+#{value.bonus_value})")
    end
    
    def display_debug()
      out = ''
      self.values.each do |value|
        out += ",#{value.short_label}:#{value.base_value}(#{value.adjusted_value})"
      end
      out.ltrim(',')
    end
   
  end
end
