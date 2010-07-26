class FeedCategory
  attr_accessor :title, :order

  #over-ride to_s to help FeedDefinition <=> pass tests when definitions yml isn't memoized
  def to_s
    "FeedCategory: title=#{self.title}, order=#{self.order.to_s}"
  end
end
