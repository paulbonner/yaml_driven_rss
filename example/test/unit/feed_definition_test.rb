
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "../../../config/environment")
require 'test_help'
require 'test/shoulda_macros/rss_macros'

class FeedDefinitionTest < Test::Unit::TestCase
	context "The feed definition class " do
		should "return an Array from its definitions_array method" do
			assert FeedDefinition.definitions_array.is_a?(Array), FeedDefinition.definitions_array.inspect
		end
		
		should "return only instances of the FeedDefinition class in its definitions_array" do
			FeedDefinition.definitions_array.each{|fd| assert fd.is_a?(FeedDefinition) }
		end
	
		should "return a Hash from its definitions_hash method" do
			assert FeedDefinition.definitions_hash.is_a?(Hash)
		end
		
		should "return an equal number of array and hash elements from its definitions_array and defintions_hash methods" do
			assert FeedDefinition.definitions_hash.keys.size==FeedDefinition.definitions_array.size
		end
		
		should "return an instance of the FeedDefinition class for each key in the definitions_hash" do
			assert FeedDefinition.definitions_hash.keys.each{|key| FeedDefinition.definitions_hash[key].is_a?(FeedDefinition)}
		end

    should "be able to find a definition by name" do
      assert FeedDefinition.find(FeedDefinition.definitions_array.last.name)=== FeedDefinition.definitions_array.last
    end

		should "return a formatted file-size string in response to its formatted_file_size method" do
      assert FeedDefinition.formatted_file_size(1234567890) == '1.1 GB'
		end
    should "return an array of FeedCategory objects" do
      assert FeedDefinition.categories.each{|cat| cat.is_a?(FeedCategory)}
    end
	end

  context "An instance of the feed definition class" do
    test_feed=FeedDefinition.definitions_array.first
    should_require_a_value_for :feed=>test_feed, :columns=>[:category, :name, :title, :description,:count,:select_clause,:from_clause,:conditions_clause]
    should_be_valid_if_all_required_fields_populated :feed=>test_feed
    should_be_invalid_if_lacking_a_value_for :feed=>test_feed,  :columns=>[:category, :name, :title, :description,:count,:select_clause,:from_clause,:conditions_clause]
    should_accept_but_not_require_a_value_for :feed=>test_feed, :columns=>[:order_by,:query_processing]

  end
  

end
