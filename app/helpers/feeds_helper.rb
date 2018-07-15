module FeedsHelper
  # Return the latest published article for a list of articles.
  #
  # @param articles [Array] List of articles
  # @return [Hash] Latest published article
  def latest_published_article(articles)
    articles_temp_store = articles.select { |article| article.published_date.present? }
    articles_temp_store.sort_by{ |article| article.published_date }.last
  end

  # Return the earliest published article for a list of articles.
  #
  # @param articles [Array] List of articles
  # @return [Hash] Latest published article
  def earliest_published_article(articles)
    articles_temp_store = articles.select { |article| article.published_date.present? }
    articles_temp_store.sort_by{ |article| article.published_date }.first
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
