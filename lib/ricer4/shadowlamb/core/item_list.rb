module Ricer4::Plugins::Shadowlamb::Core
  class ItemList < ActiveRecord::Base

    self.table_name = 'sl5_item_lists'
    
    include Include::Base
    include Include::Translates

    belongs_to :owner, :polymorphic => true
    
    has_many :items, :class_name => Item.name, :dependent => :destroy # , :autosave => true

    ###############
    ### Install ###
    ###############
    arm_install do |m|
      m.create_table table_name do |t|
        t.string  :list_name,  :limit => 16,  :null => false, :charset => :ascii, :collation => :ascii_bin
        t.integer :owner_id,   :limit => 11,  :null => false
        t.string  :owner_type, :limit => 128, :null => false, :charset => :ascii, :collation => :ascii_bin
      end
      m.add_index table_name, [:owner_id, :owner_type], :name => :itemlist_owners
    end

    ###############
    ### Display ###
    ###############
    # def display_items; self.class.display_items(self.items); end
    # def self.display_items(items); lib.human_join(Array(items).collect{|item|item.display_name}); end
    # def display_selected_items(); self.class.display_selected_items(self.items); end
    # def self.display_selected_items(items); lib.human_join(Array(items).collect{|item|item.display_name_selected}); end
    
    ### Weight
    def self.weight(items=[]); weight = 0; items.each{|item|weight+=item.adjusted_value(:weight)}; weight; end
    def weight; self.class.weight(self.items); end
    
    
    #############
    ### Cache ###
    #############
    def add_item(item)
      add_items(item)
    end
    
    def add_items(items)
      bot.log.debug("#{owner.display_name} receives items #{self.class.display_items(items)} in #{self.list_name}")
      Array(items).each do |item|
        if !merge_item!(item)
          self.items.push(item)
          item.save!
        end
      end
      self.save!
      self
    end
    
    def merge_item!(new_item)
      self.items.each do |old_item|
        if (old_item.stackable?) && (old_item.item_name_id == new_item.item_name_id)
          old_item.add_amount(new_item.amount)
          old_item.save!
          new_item.destroy!
          return true # merged!
        end
      end
      false # not merged!
    end

    # def remove_item(item)
      # remove_items(item)
    # end
# 
    # def remove_items(items)
      # Array(items).each do |item|
        # self.items.delete(item)
      # end
      # self
    # end

    # def optimize_items
      # item_factory.optimize_items(self.items)
      # self
    # end

    ##########################
    ### Item search engine ###
    ##########################
    # def amount_arg(arg, default=1)
      # return default if arg.nil? || arg.empty?
      # return 65535 if arg.downcase == 'x'
      # amount = arg.to_i
      # raise StandardError.new("Amount has to be >= 1") if amount < 1
      # amount
    # end
# 
    # def at_position(position)
      # at_position!(position) rescue nil
    # end
#     
    # def at_position!(position)
      # match = /^([0-9]*|x?)x?(\d+)$/.match(position)
      # amount = amount_arg(match[1])
      # item = items[match[2].to_i-1] || (raise Ricer4::ExecutionException.new(t(:err_item_not_found)))
      # item.selected_amount = amount
      # item
    # end
#     
    # def for_range(arg)
      # for_range!(arg) rescue nil
    # end
# 
    # def for_range!(arg)
      # range = /^([0-9x]+x)?(\d*)-(\d*)$/.match(arg)
      # amount = amount_arg(range[1], 65535)
      # from = range[2].to_i rescue 1
      # to = range[3].to_i rescue self.items.size
      # items = for_range_of!(from, to)
      # items.each do |item|
        # item.selected_amount_maxxed(amount)
      # end
      # items
    # end
#     
    # def for_range_of(from, to)
      # for_range!(from, to) rescue nil
    # end
# 
    # def for_range_of!(from, to)
      # raise Ricer4::ExecutionException.new(t(:err_range_low, from: from, to: to)) if from < 1
      # raise Ricer4::ExecutionException.new(t(:err_range_high, from: from, to: to)) if to > items.size
      # items[(from-1)..to]
    # end
# 
    # def search_single_item(arg)
      # search_single_item!(arg) rescue nil
    # end
# 
    # def search_single_item!(arg)
      # if item = at_position(arg)
        # return item
      # end
      # items = search_items(arg)
      # raise Ricer4::ExecutionException.new(t(:err_item_not_found)) if items.count == 0
      # raise Ricer4::ExecutionException.new(t(:err_item_ambigious)) if items.count > 1
      # item = items.first
      # item.selected_amount = 1
      # item
    # end
#     
    # def search_first_item(arg)
      # search_first_item!(arg) rescue nil
    # end
#     
    # def search_first_item!(arg)
      # if item = at_position(arg)
        # return item
      # end
      # items = search_items(arg)
      # raise Ricer4::ExecutionException.new(t(:err_item_not_found)) if items.count == 0
      # items.first
    # end
#     
    # def search_items(arg)
      # match = /^([0-9]+|x)x/.match(arg)
      # amount = 1
      # if match
        # amount = amount_arg(match[1])
        # arg = arg.ltrim('0123456789xX')
      # end
      # first, last, middle, arg = arg[0] == '*', arg[-1] == '*', first && last, arg.downcase.trim('*')
      # raise Ricer4::ExecutionException.new(t(:err_item_search_too_short, :letters => 3)) if arg.length < 3
      # back = []
      # items.each do |item|
        # full_name = item.display_name.downcase
        # if (full_name == arg) ||
           # (middle && full_name.index(arg)) ||
           # (first && full_name.end_with?(arg)) ||
           # (last && full_name.start_with?(arg))
           # back.push(item.selected_amount_maxxed(amount))
         # end
      # end
      # back
    # end
#     
    # def search_items_with_range(args)
      # items, args = [], args.gsub(/ *- */, '-').gsub(/ +/, ',')
      # args.split(',').each do |arg|
        # more_items = search_items_with_range_arg(arg)
        # unless more_items.nil?
          # Array(more_items).each do |item|
            # items.push(item) unless items.include?(item)
          # end
        # end
      # end
      # items
    # end
#     
    # def search_items_with_range_arg(arg)
      # at_position(arg) || for_range(arg) || search_items(arg)
    # end
    
  end
end
