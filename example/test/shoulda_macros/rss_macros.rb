# To change this template, choose Tools | Templates
# and open the template in the editor.
module RssMacros
  class Test::Unit::TestCase
    def self.should_require_a_value_for(opts={})
      opts[:columns].each{|sym|
        feed=opts[:feed].clone
        should "should require a value for #{sym}" do
          assert feed.valid?, feed.inspect
          assert ! feed.send(sym).nil?, feed.inspect
          feed.send(sym.to_s + "=", nil)
          assert ! feed.valid?, feed.inspect
        end
      }
    end

    def self.should_be_invalid_if_lacking_a_value_for(opts={})
      feed=opts[:feed]
      opts[:columns].each{|sym|
        should "be invalid if lacking a value for #{sym}" do
          test_feed=feed.clone
          test_feed.send(sym.to_s + "=",nil)
          assert ! test_feed.valid?, test_feed.inspect
        end
      }
    end

    def self.should_accept_but_not_require_a_value_for(opts={})
      opts[:columns].each{|sym|
        feed=opts[:feed].clone
        should "accept but not require a value for #{sym}" do
          assert feed.valid? && feed.respond_to?(sym.to_s + "=")
          feed.send(sym.to_s + "=", "dog")
          assert feed.valid?
          feed.send(sym.to_s + "=", nil)
          assert feed.valid?, feed.inspect
        end
      }
    end

    def self.should_be_valid_if_all_required_fields_populated(opts={})
      should "be valid if all required fields populated" do
        assert opts[:feed].valid?, opts[:feed].inspect
      end
    end

  end
end