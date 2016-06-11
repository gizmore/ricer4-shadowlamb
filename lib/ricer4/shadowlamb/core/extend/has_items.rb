module Ricer4::Plugins::Shadowlamb::Core::Extend::HasItems
  def has_items(accessor=:items, options={})
    class_eval do |klass|
      options.reverse_merge!({
        :as => :owner,
#        :autosave => true,
        :dependent => :destroy,
        :class_name => 'Ricer4::Plugins::Shadowlamb::Core::ItemList',
      })
      has_one accessor, -> { where(:list_name => accessor) }, options
    end
  end
end
