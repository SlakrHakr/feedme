module FeedsHelper
  # Determine and return title for resource.
  #
  # @param resource [Feed/Article] Feed or article to extract title from
  # @return [String] Title of resource
  def parse_for_title(resource)
    return resource.title if resource.title.present?
  end

  # Determine and return correct primary url for resource.
  #
  # @param resource [Feed/Article] Feed or article to extract primary url from
  # @return [String] Primary url of resource
  def parse_for_url(resource)
    return resource.feed_url if resource.respond_to?('feed_url') && resource.feed_url.present?
    return resource.url if resource.url.present?
  end

  # Determine and return correct image source for resource.
  #
  # @param resource [Feed/Article] Feed or article to extract image source from
  # @return [String] Url of image
  def parse_for_image_source(resource)
    return resource.image.url if resource.respond_to?('image') && resource.image.respond_to?('url')
  end

  # Determine and return description for provided resource.
  #
  # @param resource [Feed/Article] Feed or article to extract description from
  # @return [String] Description of resource
  def parse_for_description(resource)
    return resource.description if resource.respond_to?('description') && resource.description.present?
    return resource.summary if resource.summary.present?
  end

  # Determine and return published date of an article.
  #
  # @param article [Article] Article to extract published date from
  # @return [String] Date article was published
  def parse_for_published_date(article)
    return article.published if article.published.present?
  end

  def latest_published_article(articles)
    # TODO
  end

  def earliest_published_article(articles)
    # TODO
  end
end
