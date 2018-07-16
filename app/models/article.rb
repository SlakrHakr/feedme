class Article < ApplicationRecord
  belongs_to :feed
  has_many :properties

  def read=(value)
    property = Property.find_by(article: self, user: User.current, key: 'READ')
    property = Property.new(article: self, user: User.current, key: 'READ') unless property.present?
    property.value = value

    property.save
  end

  def read?
    property = Property.find_by(article: self, user: User.current, key: 'READ')
    property.present? ? ActiveModel::Type::Boolean.new.cast(property.value) : false
  end
end
