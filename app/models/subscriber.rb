class Subscriber < ActiveRecord::Base
  has_many :subscriptions
  has_many :lists, :through => :subscriptions
  
  attr_accessible :name, :email
end
