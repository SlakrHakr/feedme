class FeedsController < ApplicationController
  def index
    @feeds = current_user.feeds
  end

  def show
    sort_by = params['sort_by']
    sort_order = params['sort_order']
    @sort_by = (sort_by.present? && sort_order.present?) ? { sort_by.to_sym => sort_order } : { published_date: 'desc' }

    @feed = current_user.feeds.detect{ |feed| feed.id == params[:id].to_i }
    raise ActiveRecord::RecordNotFound unless @feed.present?
  end

  def new
    @feed = Feed.new(users: [current_user])
  end

  def create
    feed = Feed.build_from_url(params[:feed][:url], current_user)
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
