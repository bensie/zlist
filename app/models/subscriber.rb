class Subscriber < ActiveRecord::Base
  has_many :lists, :through => :subscriptions
  has_many :subscriptions
  
  attr_accessible :name, :email
end
