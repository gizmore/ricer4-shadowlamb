module Ricer4::Plugins::Shadowlamb
  class Look < Core::Command
    
    requires_player

    is_list_trigger :look, :for => true, :search_pattern => nil, :per_page => 10
    

    def search_class
      PaginatedArray.new(player.visible_players)
    end
    
    def execute_list(page)
      execute_show_items(search_class, page)
    end
    
    ###############
    ### Display ###
    ###############
    def display_list_item(item, number)
      "#{number}-#{item.display_name}"
    end

    def display_show_item(item, number)
      "#{number}-#{item.display_name}"
    end
    
    # def search_class
      # PaginatedArray.new
    # end
#     
    # def search_relation(relation, arg)
      # return relation.search(arg) if relation.respond_to?(:search)
      # relation.where(:id => arg)
    # end
#     
    # def visible_relation(relation)
      # return relation.visible(user) if relation.respond_to?(:visible)
      # relation
    # end

    # has_usage  '<page>', function: :_execute_look
    # has_usage :_execute_look
    # def _execute_look(page=1)
      # execute_look(player, page)
    # end

    # def execute_look(player, page)
      # players = PaginatedArray(player.visible_players)
      # rplyr :err_page if page > players
      # out = .collect{|p|p.display_name}
      # rply :msg_see_none if out.empty?
      # rply :msg_seeing, players: human_join(out)
    # end
      
  end
end
