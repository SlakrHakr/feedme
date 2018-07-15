class FeedSyncJob < ActiveJob::Base
  def perform
    Feed.all.each { |feed| feed.update_local_storage }
  end
end
