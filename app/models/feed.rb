class Feed < ApplicationRecord
  has_many :articles
  has_and_belongs_to_many :users

  # Update local store with any changes to feed / new articles.
  #
  # @return [boolean] true if success, false if failure
  def update_local_storage
    xml = HTTParty.get(self.url).body
    content = Feedjira.parse(xml)

    self.title = Feed.parse_for_title(content)
    self.image = Feed.parse_for_image_source(content)
    self.articles += Feed.convert_articles(content.entries).select do |article|
      is_new = true
      self.articles.each do |existing_article|
        if (existing_article.title == article.title && existing_article.published_date == article.published_date)
          is_new = false
          break
        end
      end
      is_new
    end

    self.save
  end

  # Retrieve current content for feed if not already stored in our system.
  # Returns existing Feed if already known to our system.
  #
  # @param url [string] Feed url to retrieve content for
  # @param user [User] default: nil, User to associate feed with
  # @return [Feed] An instance of our Feed structure
  def self.build_from_url(url, user = nil)
    feed = Feed.find_by url: url
    if feed.present?
      if user.present?
        feed.users.push(user) unless feed.users.include?(user)
      end
      return feed
    end

    xml = HTTParty.get(url).body
    content = Feedjira.parse(xml)

    feed = Feed.new(url: url)
    feed.users = [user] if user.present?
    feed.title = parse_for_title(content)
    feed.image = parse_for_image_source(content)
    feed.articles = convert_articles(content.entries)

    feed
  end

  private
    def self.convert_articles(entries)
      entries.map do |entry|
        article = Article.new(title: parse_for_title(entry))
        article.url = parse_for_url(entry)
        article.published_date = parse_for_published_date(entry)
        article.description = parse_for_description(entry)

        article
      end
    end

    # Determine and return title for resource.
    #
    # @param resource [Feed/Article] Feed or article to extract title from
    # @return [String] Title of resource
    def self.parse_for_title(resource)
      return resource.title if resource.respond_to?('title') && resource.title.present?
    end

    # Determine and return correct primary url for resource.
    #
    # @param resource [Feed/Article] Feed or article to extract primary url from
    # @return [String] Primary url of resource
    def self.parse_for_url(resource)
      return resource.feed_url if resource.respond_to?('feed_url') && resource.feed_url.present?
      return resource.url if resource.respond_to?('url') && resource.url.present?
    end

    # Determine and return correct image source for resource.
    #
    # @param resource [Feed/Article] Feed or article to extract image source from
    # @return [String] Url of image
    def self.parse_for_image_source(resource)
      return resource.image.url if resource.respond_to?('image') && resource.image.respond_to?('url') && resource.image.url.present?
    end

    # Determine and return description for provided resource.
    #
    # @param resource [Feed/Article] Feed or article to extract description from
    # @return [String] Description of resource
    def self.parse_for_description(resource)
      return resource.description if resource.respond_to?('description') && resource.description.present?
      return resource.summary if resource.respond_to?('summary') && resource.summary.present?
      return resource.content if resource.respond_to?('content') && resource.content.present?
    end

    # Determine and return published date of an article.
    #
    # @param article [Article] Article to extract published date from
    # @return [String] Date article was published
    def self.parse_for_published_date(article)
      return article.published if article.respond_to?('published') && article.published.present?
    end
end
