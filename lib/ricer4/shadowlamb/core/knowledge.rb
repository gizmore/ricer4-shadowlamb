module Ricer4::Plugins::Shadowlamb::Core
  class Knowledge < ActiveRecord::Base
    
    self.table_name = 'sl5_knowledges'
    
    include Include::Base
    include Include::Translates
    arm_events

    belongs_to :player,    :class_name  => "Ricer4::Plugins::Shadowlamb::Core::Player"
    belongs_to :knowledge, :polymorphic => true
    
    ###############
    ### Install ###
    ###############
    arm_install('Ricer4::Plugins::Shadowlamb::Core::Player' => 1) do |m|
      m.create_table table_name do |t|
        t.integer :player_id,       :null => false
        t.integer :knowledge_id,    :null => false
        t.string  :knowledge_type,  :null => false, :limit => 128, :charset => :ascii, :collation => :ascii_bin
#          t.boolean :visited,         :null => false, :default => false
        t.foreign_key :sl5_players, :name => :knowledge_players, :column => :player_id
      end
      m.add_index table_name, [:player_id, :knowledge_type], :name => :quick_knowledge_index
    end
    
    ##############
    ### Events ###
    ##############
    arm_subscribe('party/enters/area') do |sender, party, old_area, new_area|
      teach_party_area(party, new_area)
    end

    arm_subscribe('party/reaches/location') do |sender, party, old_location, new_location|
      teach_party_location(party, new_location)
    end
    
    ###################
    ### Convinience ###
    ###################
    def self.teach_party_word(party, word)
      party.members.each{|member|teach_player_word(member, word)}
    end

    def self.teach_party_area(party, area)
      party.members.each{|member|teach_player_area(member, area)}
    end
    
    def self.teach_party_location(party, location)
      party.members.each{|member|teach_player_location(member, location)}
    end

    def self.teach_player_word(player, word)
      if teach_player_knowledge(player, word)
        player.localize!.send_message(I18n.t('shadowlamb.msg_learned_word',
          word: word.display_name,
        ))
      end
    end
    
    def self.teach_player_area(player, area)
      if teach_player_knowledge(player, area)
        player.localize!.send_message(I18n.t('shadowlamb.msg_learned_area',
          area: area.display_name,
          info: area.displayinfo,
          squarekm: area.squarekm.round(2),
        ))
      end
    end

    def self.teach_player_location(player, location)
      if teach_player_knowledge(player, location)
        player.localize!.send_message(I18n.t('shadowlamb.msg_learned_location',
          info: location.displayinfo,
          location: location.display_name,
        ))
      end
    end

    ################
    ### Learning ###
    ################
    def self.teach_player_knowledge(player, what)
      # learned already
      player.knowledges.each{|k| return false if k.knowledge == what}
      what.save!
      player.knowledges.create!({knowledge: what})
      true
    end
    
  end
end
