module Ricer4::Plugins::Shadowlamb
  module Core
    module Include
      module ParseParamRelation
        
        def parse_param_relation(relation, input)
          result = parse_param_relations(relation, input)
          invalid!(:err_unknown) if result.nil?
          return result.first if result.length == 1
          invalid!(:err_ambigious)
        end
      
        def parse_param_relations(relation, input)
          input.downcase!
          return Array(relation[input.to_i-1]) rescue nil if input.integer?
          result = relation.select{|r| r.display_name.downcase == input }
          return result if result.length >= 1
          result = relation.select{|r| r.display_name.downcase.start_with?(input) }
          return result if result.length >= 1
          result = relation.select{|r| r.display_name.downcase.index(input) }
          return result if result.length >= 1
          nil
        end

      end
    end
  end
end