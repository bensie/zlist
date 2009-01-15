class List < ActiveRecord::Base
  has_many :subscriptions, :dependent => :destroy
  has_many :subscribers, :through => :subscriptions
  has_many :topics
  
  validates_presence_of :name
end
