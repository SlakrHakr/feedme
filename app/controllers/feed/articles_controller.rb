class Feed::ArticlesController < ApplicationController
  def update
    feed_id = params[:feed_id].to_i
    article_id = params[:id].to_i
    read = ActiveModel::Type::Boolean.new.cast(params[:read])

    feed = Feed.find(feed_id)
    article = feed.articles.detect { |article| article.id == article_id }
    article.read = read

    redirect_to feed
  end
end
