class List < ActiveRecord::Base
  has_many :subscribers, :through => :subscriptions
  
  validates_presence_of :name
end
