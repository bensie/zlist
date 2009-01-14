class List < ActiveRecord::Base
  has_many :subscriptions
  has_many :subscribers, :through => :subscriptions
  has_many :threads
  
  validates_presence_of :name
end
