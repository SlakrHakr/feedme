class FeedsController < ApplicationController
  def index
    @feeds = feeds.map { |feed|
      xml = HTTParty.get(feed).body
      Feedjira.parse(xml)
    }
  end

  def show
    xml = HTTParty.get(feeds.sample).body
    @feed = Feedjira.parse(xml)

    @articles = @feed.entries
  end

  private
    def feeds
      [
        'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/significant_week.atom',
        'http://www.feedforall.com/sample.xml',
        'http://www.feedforall.com/blog-feed.xml',
        'https://weblog.rubyonrails.org/feed/atom.xml',
        'https://www.nasa.gov/rss/dyn/nasax_vodcast.rss'
      ]
    end
end
