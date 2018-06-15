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

  # Return the latest published article for a list of articles.
  #
  # @param articles [Array] List of articles
  # @return [Hash] Latest published article
  def latest_published_article(articles)
    articles.sort_by{ |article| article[:published_date] }.last
  end

  # Return the earliest published article for a list of articles.
  #
  # @param articles [Array] List of articles
  # @return [Hash] Latest published article
  def earliest_published_article(articles)
    articles.sort_by{ |article| article[:published_date] }.first
  end

  # Determine if an article contains an image or not.
  #
  # @return [Hash] Article to search
  def article_contains_image?(article)
    /.*<img .*>.*/ === article[:description]
  end

  # Determine if sort item is currently selected.
  #
  # @return [Boolean] True if item is currently selected, false if not
  def selected?(sort_type, sorted_by)
    sort_type.to_s.downcase == sorted_by.keys[0].to_s.downcase
  end

  # Return class for sort item based on if it is currently selected.
  #
  # @param sort_type [String] Name of sort item
  # @param sorted_by [Hash] Single item hash of currently selected sort
  # @return [String] Class to append to sort item
  def selected_class(sort_type, sorted_by)
    selected?(sort_type, sorted_by) ? 'selected' : ''
  end

  # Return next sort order for sort item based on if it is currently selected.
  #
  # @param sort_type [String] Name of sort item
  # @param sorted_by [Hash] Single item hash of currently selected sort
  # @param default [String] Default sort if item is not currently selected
  # @return [String] Sort order to use for next sort of that item
  def sort_order(sort_type, sorted_by, default = 'asc')
    return default if not selected?(sort_type, sorted_by)
    sorted_by.values[0].to_s.downcase == 'asc' ? 'desc' : 'asc'
  end
end
