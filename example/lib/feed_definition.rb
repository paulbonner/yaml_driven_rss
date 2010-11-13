class FeedDefinition
  extend ActionView::Helpers::NumberHelper
  include Comparable
  require 'feed_category'
  require 'rss'
  require 'date'

  attr_accessor :category, :select_clause, :from_clause, :order_by, :conditions_clause, :description, :count,:name,:title, :query_processing, :updates, :link, :connection_class
  DEFAULT_CONFIG = RAILS_ROOT + "/config/feed_definitions.yml"

  @@definitions_source=nil

   def self.get_section(section_symbol)
    config = @@definitions_source ? @@definitions_source : load_config
    @@definitions_source = config if config[:defaults][:memoize]
    config[section_symbol]
  end

  def self.load_config
    begin
      puts "loading " + DEFAULT_CONFIG
      YAML.load_file(DEFAULT_CONFIG)
    rescue Errno::ENOENT
      STDERR.puts("File not found or invalid: #{f}")
    end
  end

  def self.categories
    get_section(:categories)
  end

  def self.definitions_array
    get_section(:definitions)
  end

  def self.defaults
    get_section(:defaults)
  end
 
  def self.definitions_hash
    definitions_array.inject({}){|result, element| result[(element.name).to_sym] = element; result}
  end
  
  def self.find(report_name)
    definitions_hash[report_name.to_sym]
  end

  def valid?
    [:category, :name, :title, :description,:count,:link, :select_clause,:from_clause,:conditions_clause].each{|required_field|
      (STDOUT.puts "#{self.name.to_s} is invalid, it needs a #{required_field.to_s}"; return false) if self.send(required_field).blank?
    }
    true
  end
  
  def updates(params_count)
    return all_site_updates(params_count) if self.name==FeedDefinition.defaults[:all_site_tag]
    limit=[(params_count.to_i || FeedDefinition.defaults[:max_items]), self.count].min
    connection_source=self.connection_class || FeedDefinition.defaults[:default_connection_class]
    ret=Object.const_get(connection_source).find(:all,:limit=> limit,:order=> self.sql_order , :from=>self.from_clause, :select=>self.select_clause, :conditions=>self.conditions_clause)
    self.query_processing.nil? ? ret : eval("ret." + self.query_processing.to_s)
  end
  
  def all_site_updates(params_count)
    limit=params_count.to_i
    all_updates=FeedDefinition.definitions_array.reject{|d|FeedDefinition.defaults[:all_site_exceptions].include? d.name}.inject([]) {|arr, feed_def| arr << feed_def.updates(limit)}
    all_updates.flatten.sort{|a,b| b.send(FeedDefinition.defaults[:default_sort])<=> a.send(FeedDefinition.defaults[:default_sort])}[0..limit-1]
  end
  
  def self.formatted_file_size(filesize)
    number_to_human_size(filesize,:precision=>1)
  end
  
  def self.file_extension(url)
    url.split(".").last
  end
  
  def sql_order
    self.order_by || FeedDefinition.defaults[:default_sort]
  end
  
  def <=> (anOther)
   [:category, :select_clause, :from_clause, :order_by, :conditions_clause, :description, :count,:name,:title, :query_processing, :link, :connection_class].each  do |field|
      comp= self.send(field).is_a?(Hash) ? self.send(field).values[0] <=> anOther.send(field).values[0] : self.send(field).to_s <=> anOther.send(field).to_s
      return comp unless comp == 0
   end
   return 0 
  end

end
