class FeedsController < ApplicationController
  def index
    @feeds = current_user.feeds
  end

  def show
    sort_by = params['sort_by'].present? ? params['sort_by'] : 'published_date'
    sort_order = params['sort_order'].present? ? params['sort_order'] : 'desc'
    @sort_by = { sort_by.to_sym => sort_order }

    include_read = params['include_read'].present? ? ActiveModel::Type::Boolean.new.cast(params['include_read']) : false

    @feed = current_user.feeds.detect{ |feed| feed.id == params[:id].to_i }
    raise ActiveRecord::RecordNotFound unless @feed.present?

    @articles = @feed.articles.order("#{sort_by} #{sort_order.upcase}")
    @articles = @articles.select { |article| not article.read? } unless include_read
  end

  def new
    @feed = Feed.new(users: [current_user])
  end

  def create
    feed = Feed.build_from_url(params[:feed][:url])
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
end
