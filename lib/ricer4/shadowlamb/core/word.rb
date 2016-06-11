module Ricer4::Plugins::Shadowlamb::Core
  class Word < ActiveRecord::Base
    
    include Include::Base
    include Include::Translates

    self.table_name = 'sl5_words'

    arm_cache

    ###############
    ### Install ###
    ###############   
    arm_install do |m| 
      m.create_table table_name do |t|
        t.string  :name, :limit => 32, :null => false, :collation => :ascii_bin, :charset => :ascii
      end
      m.add_index table_name, :name, :unique => true, :name => :unique_word_names
    end
    
    def self.hello
      @_hello ||= find_or_create_by(name: 'hello')
    end
    
    
    ###
    def display_name
      t!("words.#{self.name.downcase}") rescue self.name.downcase
    end
    
  end
end
