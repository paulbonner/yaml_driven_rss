class FeedController < ApplicationController
 def show
    @feed_tag=(params[:id] || "whole_site")
    unless read_fragment(@feed_tag)
      @feed = FeedDefinition.find(params[:id] || "whole_site")
    end
  end
end
