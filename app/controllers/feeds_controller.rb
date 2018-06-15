class FeedsController < ApplicationController
  def index
    feeds = Feed.where(user: current_user)
    @feeds = feeds.map { |feed|
      xml = HTTParty.get(feed.url).body
      content = Feedjira.parse(xml)

      join_feed_content(feed, content)
    }

    # Some feeds have articles that are only a primary url for the feed for some reason...
    @feeds.each { |feed| feed[:articles].delete_if { |article| article[:title].blank? } }
  end

  def show
    sort_by = params['sort_by']

    feed = Feed.where(id: params[:id].to_i, user: current_user).first
    xml = HTTParty.get(feed.url).body
    content = Feedjira.parse(xml)

    @feed = join_feed_content(feed, content)

    # Some feeds have articles that are only a primary url for the feed for some reason...
    @feed[:articles].delete_if { |article| article[:title].blank? }

    @sort_by = sort_by.present? ? sort_by : { published_date: 'desc' }
    @feed[:articles] = sort_articles(@feed[:articles], @sort_by)
  end

  def new
    @feed = Feed.new(user: current_user)
  end

  def create
    feeds = Feed.where(url: params[:feed][:url], user: current_user)
    feed = feeds.present? ? feeds.first : nil
    redirect_to feed_path(feed.id) and return if feed.present?

    feed = Feed.new(user: current_user, url: params[:feed][:url])
    xml = HTTParty.get(feed.url).body
    content = Feedjira.parse(xml)
    if feed.save
      redirect_to feed_path(feed.id)
    else
      raise "Failed to add feed: #{params[:feed][:url]}"
    end
  rescue URI::InvalidURIError, NoMethodError, Errno::ECONNREFUSED
    flash[:new_feed_form_error] = 'URL doesn\'t seem to exist. Please try again.'
    redirect_to new_feed_path
  rescue Feedjira::NoParserAvailable
    flash[:new_feed_form_error] = 'URL doesn\'t seem to be an RSS feed. Please try again.'
    redirect_to new_feed_path
  end

  private
    def join_feed_content(feed, content)
      feed = JSON.parse(feed.to_json)
      feed[:title] = helpers.parse_for_title(content)
      feed[:image] = {}
      feed[:image][:url] = helpers.parse_for_image_source(content)

      feed[:articles] = content.entries.map { |entry|
        article = {}
        article[:title] = helpers.parse_for_title(entry)
        article[:url] = helpers.parse_for_url(entry)
        article[:published_date] = helpers.parse_for_published_date(entry)
        article[:description] = helpers.parse_for_description(entry)

        article
      }

      feed.deep_symbolize_keys
    end

    def sort_articles(articles, sort_by)
      if sort_by[:title].present?
        sorted_articles = articles.sort_by{ |article| article[:title] }
        sorted_articles.reverse! if sort_by[:title] == 'desc'
        sorted_articles
      elsif sort_by[:description].present?
        sorted_articles = articles.sort_by{ |article| article[:description] }
        sorted_articles.reverse! if sort_by[:description] == 'desc'
        sorted_articles
      elsif sort_by[:published_date].present?
        sorted_articles = articles.sort_by{ |article| article[:published_date] }
        sorted_articles.reverse! if sort_by[:published_date] == 'desc'
        sorted_articles
      else
        articles
      end
    end
end
