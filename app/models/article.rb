class Article < ApplicationRecord
  belongs_to :feed
  has_many :properties

  def read=(value)
    # TODO: https://github.com/SlakrHakr/feedme/issues/2
  end
end
