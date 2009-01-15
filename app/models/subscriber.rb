class Subscriber < ActiveRecord::Base
  has_many :subscriptions, :dependent => :destroy
  has_many :lists, :through => :subscriptions

  # has_many -> "has written"
  has_many :messages
  
  validates_uniqueness_of :email
  
  attr_accessible :name, :email
end
