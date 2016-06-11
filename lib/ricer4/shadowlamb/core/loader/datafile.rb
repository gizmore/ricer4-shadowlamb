module Ricer4::Plugins::Shadowlamb::Core::Loader
  class Datafile
    
#    include Singleton

    def self.instance
      @instance ||= self.new
    end
    
    def initialize
      @files = {}
    end
    
    def get_data_file(filename)
      @files[filename] ||= load_data_file(filename)
    end
    
    def load_data_file(filename)
      YAML.load_file(File.expand_path("../../data/#{filename}.yml", __FILE__))
    end
    
  end
end