class List < ActiveRecord::Base
  has_many :subscribers, :through => :subscriptions
  has_many :subscriptions
  
  validates_presence_of :name
end
