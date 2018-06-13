class FeedsController < ApplicationController
  def index
    @feeds = Feed.where(user: current_user).map { |feed|
      xml = HTTParty.get(feed.url).body
      Feedjira.parse(xml)
    }
  end

  def show
    sort_by = params['sort_by']

    feed = Feed.find(params[:id].to_i)
    xml = HTTParty.get(feed.url).body
    @feed = Feedjira.parse(xml)

    @articles = @feed.entries
  end

  def new
    @feed = Feed.new(user: current_user)
  end

  def create
    feed = Feed.new(user: current_user, url: params[:feed][:url])
    if feed.save
      redirect_to feed_path(feed.id)
    else
      raise "Failed to add feed: #{params[:feed][:url]}"
    end
  end
end
