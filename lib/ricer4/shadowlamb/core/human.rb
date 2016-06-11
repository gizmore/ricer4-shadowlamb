load File.expand_path("../player.rb", __FILE__)
module Ricer4::Plugins::Shadowlamb::Core
  class Human < Player
    
    def is_human?; true; end
    def is_abstract?; false; end
    # def is_npc?; false; end
    # def is_mob?; false; end
    # def is_real_npc?; false; end
    # def is_stationary?; false; end
    
    def full_name
      "#{user.name}:#{user.server_id}"
    end

    # def sl5_after_killed(attacker, victim, with)
      # send_message(t(:msg_killed,
        # attacker: attacker.display_name,
        # with: with.display_name
      # ))
    # end

  end
end
