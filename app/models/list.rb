class List < ActiveRecord::Base
  has_many :subscribers, :through => :subscriptions
end
